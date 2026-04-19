// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://smr2118.github.io',
	base: '/CollegeReadiness',
	integrations: [
		starlight({
			title: 'College Readiness Hub',
			description: 'Track summer programs, internships, extra curriculars, and more.',
			customCss: ['./src/styles/custom.css'],
			components: {
				Header: './src/components/CustomHeader.astro',
				PageSidebar: './src/components/CustomPageSidebar.astro',
			},
			sidebar: [
				{ label: 'Home', link: '/' },
				{
					label: 'Programs & Activities',
					items: [
						{ label: '☀️ College Summer Programs', link: '/programs/' },
						{ label: '💼 Internships', link: '/internships/' },
						{ label: '🏆 Extra Curriculars', link: '/extracurriculars/' },
						{ label: '🇮🇳 India Activities', link: '/india-activities/' },
					],
				},
				{
					label: 'Resources',
					items: [
						{ label: '📅 Deadline Calendar', link: '/calendar/' },
						{ label: '✅ Family To-Do', link: '/todos/' },
						{ label: '📓 Notes', link: '/notes/' },
						{ label: '🔗 Reference Links', link: '/references/' },
					],
				},
				{
					label: 'Brainstorm',
					items: [
						{ label: '✍️ Essay Fodder', link: '/essay-topics/' },
						{ label: '💡 Ideas Board', link: '/ideas/' },
					],
				},
				{
					label: 'Admin',
					items: [
						{ label: '⚙️ Admin Panel', link: '/admin/' },
					],
				},
			],
		}),
	],
});
