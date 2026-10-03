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
					collapsed: true,
					items: [
						{ label: '☀️ College Summer Programs', link: '/programs/' },
						{ label: '💼 Internships', link: '/internships/' },
						{ label: '🏆 Extra Curriculars', link: '/extracurriculars/' },
						{ label: '🇮🇳 India Activities', link: '/india-activities/' },
						{ label: '📧 Cold Emailing', link: '/cold-emailing/' },
					],
				},
				{
					label: 'Brainstorm',
					collapsed: true,
					items: [
						{ label: '🎓 Colleges', link: '/college-ideas/' },
						{ label: '📖 Programs of Interest', link: '/programs-of-interest/' },
						{ label: '✍️ Essay Ideas', link: '/essay-topics/' },
						{ label: '🤖 Robotics Ideas', link: '/robotics-ideas/' },
						{ label: '🇮🇳 India Activities Ideas', link: '/india-ideas/' },
						{ label: '🏃 Extra Curriculars', link: '/ec-ideas/' },
						{ label: '🔧 Past Projects', link: '/past-projects/' },
							{ label: '🧭 Career Counselor', link: '/career/' },
					],
				},
				{
					label: 'Mind Map',
					collapsed: true,
					items: [
						{ label: '🔮 Vision Board', link: '/vision-board/' },
						{ label: '💡 Ideas Board', link: '/ideas/' },
					],
				},
				{
					label: 'Shortlists',
					collapsed: true,
					items: [
						{ label: '🎓 Colleges', link: '/shortlists/colleges/' },
						{ label: '📖 Programs of Interest', link: '/shortlists/programs/' },
						{ label: '✍️ Essay Theme', link: '/shortlists/essay-theme/' },
						{ label: '🤖 Robotics', link: '/shortlists/robotics/' },
						{ label: '🏆 Extra Curriculars', link: '/shortlists/extracurriculars/' },
						{ label: '🤝 Volunteering', link: '/shortlists/volunteering/' },
					],
				},
				{
					label: 'Goals & Tasks',
					collapsed: true,
					items: [
						{ label: '☀️ Summer 2026', link: '/goals/summer-2026/' },
					],
				},
				{
					label: 'Resources',
					collapsed: true,
					items: [
						{ label: '📅 Deadline Calendar', link: '/calendar/' },
						{ label: '✅ Family To-Do', link: '/todos/' },
						{ label: '📓 Notes', link: '/notes/' },
						{ label: '🔗 Reference Links', link: '/references/' },
						{ label: '🏫 Colleges Info', link: '/colleges/' },
					],
				},
				{
					label: 'Admin',
					collapsed: true,
					items: [
						{ label: '⚙️ Admin Panel', link: '/admin/' },
					],
				},
			],
		}),
	],
});
