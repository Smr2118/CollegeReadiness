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

    const { email, password, display_name, family_id } = await req.json()
    if (!email || !password || !family_id)
      return json({ error: 'email, password, and family_id are required' }, 400)
    if (!display_name || !display_name.trim() || display_name.trim().length < 2)
      return json({ error: 'display_name is required and must be at least 2 characters' }, 400)
    const trimmedName = display_name.trim()

    // Create auth user (email_confirm: true skips confirmation email)
    const { data: created, error: createErr } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { display_name: trimmedName, family_id, role: 'member' },
    })
    if (createErr) return json({ error: createErr.message }, 400)

    // Create user_profiles row
    const { error: profileErr } = await supabaseAdmin.from('user_profiles').insert({
      user_id: created.user.id,
      email,
      display_name: trimmedName,
      family_id,
      role: 'member',
    })
    if (profileErr) return json({ error: profileErr.message }, 400)

    return json({ success: true, user_id: created.user.id })
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
