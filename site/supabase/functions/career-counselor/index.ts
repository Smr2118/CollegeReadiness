import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const SYSTEM_PROMPT = `You are Alex, a warm and insightful college and career counselor helping a high school student discover fields of study and careers that could be a great fit for them.

The student has just been asked: "What's something you genuinely enjoy — a school subject, a hobby, or anything you find yourself doing for hours without noticing the time?" and is now responding to you.

Your process:
- Ask follow-up questions ONE AT A TIME to build a complete picture of: their strengths, subjects they're drawn to, what they want to avoid, and what kind of work or impact matters to them
- After 4-6 exchanges where you have a clear picture, provide a structured recommendations section:
  - List 3-5 fields of study as bold headings, each with a 1-sentence explanation of why it fits them
  - Under each field: 3-5 specific job titles or career paths they could pursue
  - End with one sentence of encouragement

During Q&A phase: keep each response to 2-4 warm, conversational sentences + one follow-up question. No bullet points yet.
For the final recommendations: use markdown with bold field names and bullet-point careers.

Tone: encouraging, curious, and direct. The student is trying to figure out their path — make it feel exciting.`

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors })

  try {
    const token = req.headers.get('Authorization')?.replace('Bearer ', '')
    if (!token) return json({ error: 'Unauthorized' }, 401)

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
      { auth: { autoRefreshToken: false, persistSession: false } }
    )

    const { data: { user } } = await supabase.auth.getUser(token)
    if (!user) return json({ error: 'Unauthorized' }, 401)

    const { messages } = await req.json()
    if (!Array.isArray(messages) || messages.length === 0)
      return json({ error: 'messages array required' }, 400)

    const apiKey = Deno.env.get('ANTHROPIC_API_KEY')
    if (!apiKey) return json({ error: 'ANTHROPIC_API_KEY not configured' }, 500)

    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: JSON.stringify({
        model: 'claude-sonnet-4-6',
        max_tokens: 1024,
        system: SYSTEM_PROMPT,
        messages,
      }),
    })

    if (!response.ok) {
      const errText = await response.text()
      return json({ error: `Anthropic API error: ${errText}` }, 500)
    }

    const result = await response.json()
    const reply = result.content?.[0]?.text ?? ''
    return json({ reply })
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
