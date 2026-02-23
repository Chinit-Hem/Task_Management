import { create } from 'zustand';
import * as SecureStore from 'expo-secure-store';
import { authAdapter } from '../auth/authAdapter';
import { User } from '../types/user';

// Secure storage keys
const ACCESS_TOKEN_KEY = 'accessToken';
const REFRESH_TOKEN_KEY = 'refreshToken';
const USER_KEY = 'user';

// Token refresh buffer time (5 minutes before expiry)
const TOKEN_REFRESH_BUFFER = 5 * 60 * 1000;

interface AuthState {
  user: User | null;
  accessToken: string | null;
  refreshToken: string | null;
  isLoading: boolean;
  isInitialized: boolean;
  error: string | null;
  
  // Actions
  initialize: () => Promise<void>;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string, name: string) => Promise<void>;
  logout: () => Promise<void>;
  resetPassword: (email: string) => Promise<void>;
  clearError: () => void;
  refreshTokenIfNeeded: () => Promise<boolean>;
}

export const useAuthStore = create<AuthState>((set, get) => ({
  user: null,
  accessToken: null,
  refreshToken: null,
  isLoading: false,
  isInitialized: false,
  error: null,

  initialize: async () => {
    try {
      set({ isLoading: true });
      
      // Try to load tokens from secure storage
      const accessToken = await SecureStore.getItemAsync(ACCESS_TOKEN_KEY);
      const refreshToken = await SecureStore.getItemAsync(REFRESH_TOKEN_KEY);
      const userJson = await SecureStore.getItemAsync(USER_KEY);
      
      if (accessToken && userJson) {
        const user = JSON.parse(userJson) as User;
        
        set({ 
          user, 
          accessToken, 
          refreshToken,
          isLoading: false,
          isInitialized: true 
        });
        
        // Try to refresh token in background if needed
        get().refreshTokenIfNeeded();
      } else {
        set({ 
          isLoading: false, 
          isInitialized: true 
        });
      }
    } catch (error) {
      console.error('Failed to initialize auth:', error);
      set({ 
        isLoading: false, 
        isInitialized: true,
        error: 'Failed to restore session' 
      });
    }
  },

  login: async (email: string, password: string) => {
    try {
      set({ isLoading: true, error: null });
      
      const response = await authAdapter.login({ email, password });
      
      // Store tokens securely
      await SecureStore.setItemAsync(ACCESS_TOKEN_KEY, response.accessToken);
      if (response.refreshToken) {
        await SecureStore.setItemAsync(REFRESH_TOKEN_KEY, response.refreshToken);
      }
      await SecureStore.setItemAsync(USER_KEY, JSON.stringify(response.user));
      
      set({ 
        user: response.user, 
        accessToken: response.accessToken,
        refreshToken: response.refreshToken || null,
        isLoading: false 
      });
    } catch (error: any) {
      const errorMessage = error.message || 'Login failed. Please try again.';
      set({ 
        isLoading: false, 
        error: errorMessage 
      });
      throw error;
    }
  },

  register: async (email: string, password: string, name: string) => {
    try {
      set({ isLoading: true, error: null });
      
      const response = await authAdapter.register({ email, password, name });
      
      // Store tokens securely
      await SecureStore.setItemAsync(ACCESS_TOKEN_KEY, response.accessToken);
      if (response.refreshToken) {
        await SecureStore.setItemAsync(REFRESH_TOKEN_KEY, response.refreshToken);
      }
      await SecureStore.setItemAsync(USER_KEY, JSON.stringify(response.user));
      
      set({ 
        user: response.user, 
        accessToken: response.accessToken,
        refreshToken: response.refreshToken || null,
        isLoading: false 
      });
    } catch (error: any) {
      const errorMessage = error.message || 'Registration failed. Please try again.';
      set({ 
        isLoading: false, 
        error: errorMessage 
      });
      throw error;
    }
  },

  logout: async () => {
    try {
      set({ isLoading: true });
      
      // Call logout on adapter (for server-side invalidation if needed)
      await authAdapter.logout();
      
      // Clear secure storage
      await SecureStore.deleteItemAsync(ACCESS_TOKEN_KEY);
      await SecureStore.deleteItemAsync(REFRESH_TOKEN_KEY);
      await SecureStore.deleteItemAsync(USER_KEY);
      
      set({ 
        user: null, 
        accessToken: null, 
        refreshToken: null,
        isLoading: false,
        error: null 
      });
    } catch (error) {
      console.error('Logout error:', error);
      // Still clear local state even if server logout fails
      await SecureStore.deleteItemAsync(ACCESS_TOKEN_KEY);
      await SecureStore.deleteItemAsync(REFRESH_TOKEN_KEY);
      await SecureStore.deleteItemAsync(USER_KEY);
      
      set({ 
        user: null, 
        accessToken: null, 
        refreshToken: null,
        isLoading: false,
        error: null 
      });
    }
  },

  resetPassword: async (email: string) => {
    try {
      set({ isLoading: true, error: null });
      
      await authAdapter.resetPassword(email);
      
      set({ isLoading: false });
    } catch (error: any) {
      const errorMessage = error.message || 'Password reset failed. Please try again.';
      set({ 
        isLoading: false, 
        error: errorMessage 
      });
      throw error;
    }
  },

  clearError: () => {
    set({ error: null });
  },

  refreshTokenIfNeeded: async (): Promise<boolean> => {
    const { refreshToken } = get();
    
    if (!refreshToken) {
      return false;
    }
    
    try {
      const tokens = await authAdapter.refreshToken(refreshToken);
      
      // Update stored tokens
      await SecureStore.setItemAsync(ACCESS_TOKEN_KEY, tokens.accessToken);
      if (tokens.refreshToken) {
        await SecureStore.setItemAsync(REFRESH_TOKEN_KEY, tokens.refreshToken);
      }
      
      set({ 
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken || get().refreshToken
      });
      
      return true;
    } catch (error) {
      console.error('Token refresh failed:', error);
      // If refresh fails, user needs to re-login
      await get().logout();
      return false;
    }
  },
}));

// Selector hooks for convenient access
export const useUser = () => useAuthStore((state: AuthState) => state.user);
export const useIsAuthenticated = () => useAuthStore((state: AuthState) => !!state.accessToken);
export const useIsLoading = () => useAuthStore((state: AuthState) => state.isLoading);
export const useAuthError = () => useAuthStore((state: AuthState) => state.error);
