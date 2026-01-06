import { ryoppippi } from '@ryoppippi/eslint-config';

export default ryoppippi({
	type: 'app', // or 'lib'
	svelte: true,
	typescript: {
		tsconfigPath: './tsconfig.json',
	},
});
