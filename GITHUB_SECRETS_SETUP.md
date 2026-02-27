# GitHub Secrets Setup Guide

## Required Secret: `GOOGLE_SERVICES_JSON`

The CI workflow needs `android/app/google-services.json` to build the APK.
Since this file is in `.gitignore`, you must add it as a GitHub Secret.

---

## Step 1 — Go to GitHub Secrets

1. Open: https://github.com/Chinit-Hem/Task_Management/settings/secrets/actions
2. Click **"New repository secret"**

---

## Step 2 — Add the Secret

| Field  | Value                          |
|--------|-------------------------------|
| **Name**  | `GOOGLE_SERVICES_JSON`     |
| **Secret** | *(paste the JSON below)*  |

---

## Step 3 — Copy & Paste This Value into the Secret field:

```
{"project_info":{"project_number":"974630099888","project_id":"task-management-e840c","storage_bucket":"task-management-e840c.firebasestorage.app"},"client":[{"client_info":{"mobilesdk_app_id":"1:974630099888:android:2442e168de1a0d01ef1475","android_client_info":{"package_name":"com.example.taskmanagement"}},"oauth_client":[],"api_key":[{"current_key":"AIzaSyARkeb081omBcsul9boHx2BTLK1NCpYP74"}],"services":{"appinvite_service":{"other_platform_oauth_client":[]}}}],"configuration_version":"1"}
```

> ⚠️ Copy the single line above (no line breaks) and paste it as the secret value.

---

## Step 4 — Save

Click **"Add secret"** to save.

---

## How It Works

The CI workflow (`.github/workflows/flutter.yml`) has this step:

```yaml
- name: Write google-services.json
  run: echo '${{ secrets.GOOGLE_SERVICES_JSON }}' > android/app/google-services.json
```

This writes the secret to the correct path before `flutter pub get` and `flutter build apk --debug` run.

---

## Verify CI is Working

After adding the secret, push any commit to `blackboxai/**` or `main` branch.
Check the Actions tab: https://github.com/Chinit-Hem/Task_Management/actions
