-- ============================================================
-- Grant admin role to a user by email.
-- Replace 'your@email.com' with the target user's email.
-- After running: log out and back in to refresh the JWT.
-- ============================================================

UPDATE auth.users
SET raw_user_meta_data = raw_user_meta_data || '{"role": "admin"}'::jsonb
WHERE email = 'your@email.com';

UPDATE public.user_profiles
SET role = 'admin'
WHERE user_id = (SELECT id FROM auth.users WHERE email = 'your@email.com');
