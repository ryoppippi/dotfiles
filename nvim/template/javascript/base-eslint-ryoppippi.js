import { ryoppippi } from "@ryoppippi/eslint-config";

export default ryoppippi({
  svelte: true,
  typescript: {
    tsconfigPath: "./tsconfig.json",
  },
});
