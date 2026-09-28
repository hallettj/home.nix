-- See https://github.com/microsoft/TypeScript/blob/main/tsc/internal/ls/lsutil/userpreferences.go
return {
  settings = {
    ["js/ts"] = {
      inlayHints = {
        parameterNames = {
          enabled = "all", -- "literals" (default), "all", or "" for none
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = { enabled = true },
        variableTypes = {
          enabled = true,
          suppressWhenTypeMatchesName = false,
        },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      referencesCodeLens = {
        enabled = true,
        showOnAllFunctions = true,
      },
      implementationsCodeLens = {
        enabled = true,
        showOnInterfaceMethods = true,
        showOnAllClassMethods = true,
      },
    },
  },
}
