import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors })

  try {
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
      { auth: { autoRefreshToken: false, persistSession: false } }
    )

    // Verify the caller is an admin
    const token = req.headers.get('Authorization')?.replace('Bearer ', '')
    if (!token) return json({ error: 'Unauthorized' }, 401)

    const { data: { user: caller } } = await supabaseAdmin.auth.getUser(token)
    if (!caller) return json({ error: 'Unauthorized' }, 401)
    if (caller.user_metadata?.role !== 'admin') return json({ error: 'Forbidden' }, 403)

    const { user_id, role } = await req.json()
    if (!user_id || !['admin', 'member'].includes(role))
      return json({ error: 'user_id and role (admin|member) are required' }, 400)

    // Update auth metadata so the JWT reflects the new role immediately on next login
    const { error: authErr } = await supabaseAdmin.auth.admin.updateUserById(user_id, {
      user_metadata: { role },
    })
    if (authErr) return json({ error: authErr.message }, 400)

    // Update user_profiles table
    const { error: profileErr } = await supabaseAdmin
      .from('user_profiles')
      .update({ role })
      .eq('user_id', user_id)
    if (profileErr) return json({ error: profileErr.message }, 400)

    return json({ success: true })
  } catch (err) {
    return json({ error: String(err) }, 500)
  }
})

function json(body: object, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, 'Content-Type': 'application/json' },
  })
}
