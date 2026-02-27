// Edit Profile Screen - Allows users to update their profile information

import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as provider;
import '../core/theme/app_theme.dart';
import '../core/providers/database_provider.dart';
import '../features/task_management/domain/models/user_model.dart';
import '../providers/user_session_provider.dart';


class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
=======
import '../utils/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
<<<<<<< HEAD
  late TextEditingController _locationController;
  bool _isLoading = false;
  bool _isLoadingData = true;
=======
  bool _isLoading = false;
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    _locationController = TextEditingController();
    
    // Load user data after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }


=======
    // Initialize with current user data
    _nameController = TextEditingController(text: 'Chinit Hem');
    _emailController = TextEditingController(text: 'chinithem81@email.com');
    _phoneController = TextEditingController(text: '+855 113 111 61');
    _bioController = TextEditingController(text: 'Product manager and task enthusiast');
  }

>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
<<<<<<< HEAD
    _locationController.dispose();
    super.dispose();
  }

  /// Load user data from database and session
  Future<void> _loadUserData() async {
    setState(() {
      _isLoadingData = true;
    });

    try {
      // First try to load from session
      final sessionProvider = provider.Provider.of<UserSessionProvider>(
        context,
        listen: false,
      );
      
      // Then load from database
      final isar = await ref.read(databaseProvider.future);
      final user = await isar.userModels.where().idGreaterThan(0).findFirst();


      if (mounted) {
        setState(() {
          if (sessionProvider.name != null) {
            _nameController.text = sessionProvider.name!;
          } else if (user != null && user.name.isNotEmpty) {
            _nameController.text = user.name;
          } else {
            _nameController.text = 'Chinit Hem';
          }

          if (sessionProvider.email != null) {
            _emailController.text = sessionProvider.email!;
          } else if (user != null && user.email.isNotEmpty) {
            _emailController.text = user.email;
          } else {
            _emailController.text = 'chinithem81@gmail.com';
          }

          if (sessionProvider.phone != null) {
            _phoneController.text = sessionProvider.phone!;
          } else if (user != null && user.phone != null) {
            _phoneController.text = user.phone!;
          } else {
            _phoneController.text = '+855 011 311 161';
          }

          _bioController.text = user?.bio ?? 'Product manager and task enthusiast';
          _locationController.text = user?.location ?? 'Phnom Penh, Cambodia';
          
          _isLoadingData = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      if (mounted) {
        setState(() {
          // Set defaults if loading fails
          _nameController.text = 'Chinit Hem';
          _emailController.text = 'chinithem81@gmail.com';
          _phoneController.text = '+855 011 311 161';
          _bioController.text = 'Product manager and task enthusiast';
          _locationController.text = 'Phnom Penh, Cambodia';
          _isLoadingData = false;
        });
      }
    }
  }

  /// Save profile to database and update session
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final isar = await ref.read(databaseProvider.future);
      final sessionProvider = provider.Provider.of<UserSessionProvider>(
        context,
        listen: false,
      );

      // Create or update user profile
      final user = UserModel()
        ..name = _nameController.text.trim()
        ..email = _emailController.text.trim()
        ..phone = _phoneController.text.trim()
        ..bio = _bioController.text.trim()
        ..location = _locationController.text.trim()
        ..updatedAt = DateTime.now();

      // Check if user exists
      final existingUser = await isar.userModels.where().idGreaterThan(0).findFirst();


      await isar.writeTxn(() async {
        if (existingUser != null) {
          user.id = existingUser.id;
          user.createdAt = existingUser.createdAt;
          await isar.userModels.put(user);
        } else {
          user.createdAt = DateTime.now();
          await isar.userModels.put(user);
        }
      });

      // Update session provider
      await sessionProvider.setUserInfo(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );
=======
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
          SnackBar(
            content: Text(
              'Profile updated successfully!',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Return to previous screen
        context.pop();
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update profile: $e',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
=======
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context);
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
      }
    }
  }

<<<<<<< HEAD

=======
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
<<<<<<< HEAD
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
=======
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
<<<<<<< HEAD
            onPressed: (_isLoading || _isLoadingData) ? null : _saveProfile,
=======
            onPressed: _isLoading ? null : _saveProfile,
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
<<<<<<< HEAD
                : Text(
                    'Save',
                    style: GoogleFonts.inter(
=======
                : const Text(
                    'Save',
                    style: TextStyle(
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
<<<<<<< HEAD
      body: _isLoadingData
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar Section
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.primary,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Field
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // Location Field
                    _buildTextField(
                      controller: _locationController,
                      label: 'Location',
                      hint: 'Enter your location',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 16),

                    // Bio Field
                    _buildTextField(
                      controller: _bioController,
                      label: 'Bio',
                      hint: 'Tell us about yourself',
                      icon: Icons.info_outline,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save Changes',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
=======
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
                      ),
                    ),
                  ],
                ),
              ),
<<<<<<< HEAD
            ),
    );
  }


=======
              const SizedBox(height: 32),

              // Name Field
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Field
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Bio Field
              _buildTextField(
                controller: _bioController,
                label: 'Bio',
                hint: 'Tell us about yourself',
                icon: Icons.info_outline,
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
<<<<<<< HEAD
          style: GoogleFonts.inter(
=======
          style: const TextStyle(
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
<<<<<<< HEAD
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
=======
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
<<<<<<< HEAD
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
=======
>>>>>>> 9bbc3a6a66f889ad2d6e80e2cf7e89de93a01f62
          ),
          validator: validator,
        ),
      ],
    );
  }
}
