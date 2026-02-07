"secondaryExplorer.paths": [
    // Simple string paths (support ${workspaceFolder} and ${userHome})
    "${workspaceFolder}/",

    // Or rich objects with filtering and custom name
    {
      "basePath": "${workspaceFolder}",
      "name": "user.js",
      "include": ["*.user.js"], // include: only file patterns
      "exclude": [] // exclude: file or folder patterns
    }
  ]