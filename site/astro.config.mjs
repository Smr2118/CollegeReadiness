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
				PageSidebar: './src/components/CustomPageSidebar.astro',
			},
			sidebar: [
				{ label: 'Home', link: '/' },
				{
					label: 'Opportunities',
					items: [
						{ label: '☀️ Summer Programs', link: '/programs/' },
						{ label: '💼 Internships', link: '/internships/' },
						{ label: '🏆 Extra Curriculars', link: '/extracurriculars/' },
						{ label: '🇮🇳 India Activities', link: '/india-activities/' },
					],
				},
				{
					label: 'Resources',
					items: [
						{ label: '💡 Ideas Board', link: '/ideas/' },
						{ label: '🔗 Reference Links', link: '/references/' },
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
