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

    const token = req.headers.get('Authorization')?.replace('Bearer ', '')
    if (!token) return json({ error: 'Unauthorized' }, 401)

    const { data: { user: caller } } = await supabaseAdmin.auth.getUser(token)
    if (!caller) return json({ error: 'Unauthorized' }, 401)

    const callerRole = caller.user_metadata?.role
    if (callerRole !== 'admin' && callerRole !== 'family_head')
      return json({ error: 'Forbidden' }, 403)

    let { email, password, display_name, family_id } = await req.json()
    if (!email || !password) return json({ error: 'email and password are required' }, 400)
    if (!display_name || !display_name.trim() || display_name.trim().length < 2)
      return json({ error: 'display_name is required and must be at least 2 characters' }, 400)

    // Family heads can only add users to their own family — look it up server-side
    if (callerRole === 'family_head') {
      const { data: callerProfile } = await supabaseAdmin
        .from('user_profiles')
        .select('family_id')
        .eq('user_id', caller.id)
        .single()
      if (!callerProfile?.family_id)
        return json({ error: 'Your account has no associated family' }, 403)
      family_id = callerProfile.family_id // always override — never trust the request body
    }

    if (!family_id) return json({ error: 'family_id is required' }, 400)

    const trimmedName = display_name.trim()

    const { data: created, error: createErr } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { display_name: trimmedName, family_id, role: 'member' },
    })
    if (createErr) return json({ error: createErr.message }, 400)

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
