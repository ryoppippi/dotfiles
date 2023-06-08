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
        "meet.google.com",
      ]),
      browser: "Google Chrome"
    },
  ]
};

