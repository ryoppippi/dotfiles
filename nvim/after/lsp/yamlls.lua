return {
	settings = {
		yaml = {
			schemas = require("schemastore").yaml.schemas({
				extra = {
					{
						name = "openAPI 3.0",
						url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.yaml",
					},
					{

						name = "openAPI 3.1",
						url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.yaml",
					},
				},
			}),
			validate = true,
			format = { enable = true },
		},
	},
}
