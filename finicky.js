module.exports = {
  defaultBrowser: "Safari",
  rewrite: [
    {
      match: ({url}) => url.host.includes(".google.com") && (url.search.includes("project=stailer") || url.search.includes("project=tabely")),
      url: ({url}) => {
          return {
              ...url,
              search: url.search + "&authuser=1"
          }
      }
    }
//     ,
//     {
//       // Redirect all urls to use https
//       match: ({ url }) => url.protocol === "http" && !url.host.includes("localhost"),
//       url: { protocol: "https" }
//     }
  ],
  handlers: [
    {
      // Open apple.com and example.org urls in Safari
      match: finicky.matchHostnames(["apple.com"]),
      browser: "Safari"
    },
    {
      match: finicky.matchHostnames([
        "colab.research.google.com",
      ]),
      browser: "Microsoft Edge Dev"
    },
//     {
//       match: finicky.matchHostnames([
//         "github.com",
//         /.*\.github.com$/,
//         /.*\.github.us$/
//       ]),
//       browser: "Microsoft Edge"
//     },
    {
      match: finicky.matchHostnames([
        "circleci.com",
        /.*\.circleci.com$/ 
      ]),
      browser: "Microsoft Edge Dev"
    },
//     {
//       match: finicky.matchHostnames([
//         "zoom.us",
//         /.*\.zoom.us$/ 
//       ]),
//       browser: "Microsoft Edge"
//     },
    {
      match: finicky.matchHostnames([
        "google.com",
        /.*\.google.com$/ 
      ]),
      browser: "Microsoft Edge Dev"
    },
  ]
};

