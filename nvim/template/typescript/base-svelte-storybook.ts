import type { Meta, StoryObj } from '@storybook/svelte';

import {{_input_:component}} from './{{_input_:component}}.svelte';

const meta: Meta<{{_input_:component}}> = {
	component: {{_input_:component}},
	tags: ['autodocs'],
  argTypes: {
    {{_cursor_}}
  }
};

export default meta;
type Story = StoryObj<{{_input_:component}}>;

export const Default: Story = {
	args: {}
};

