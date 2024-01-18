// This file was automatically added by edgio init.
// You should commit this file to source control.
// Learn more about this file at https://docs.edg.io/guides/edgio_config
module.exports = {
  // The name of the site in Edgio to which this app should be deployed.
  name: "swapi-elixir-profiq",

  // The name of the organization in Edgio to which this app should be deployed.
  organization: "profiq",

  // Overrides the default path to the routes file. The path should be relative to the root of your app.
  // routes: 'routes.js',

  // When set to true or omitted entirely, Edgio includes the deployment number in the cache key,
  // effectively purging the cache each time you deploy.
  purgeCacheOnDeploy: false,
  // purgeCacheOnDeploy: false,

  // Uncomment the following to specify environment specific configs
  environments: {
    dev: {
      hostnames: [{ hostname: 'swapi-dev.profiq.com' }],
      origins: [
        {
          // The name of the backend origin
          name: "origin",
    
          // Use the following to override the host header sent from the browser when connecting to the origin
          override_host_header: "swapi-elixir-dev.fly.dev",
    
          // The list of origin hosts to which to connect
          hosts: [
            {
              // The domain name or IP address of the origin server
              location: "swapi-elixir-dev.fly.dev",
            },
          ],
    
          tls_verify: {
            use_sni: true,
            sni_hint_and_strict_san_check: "swapi-elixir-dev.fly.dev",
          },
    
          // Uncomment the following to configure a shield
          shields: {
            "emea": "FRB",
            "us_west": "LAA"
          }
    
        },
      ],
    },
    production: {
      hostnames: [{ hostname: 'swapi.profiq.com' }],
      origins: [
        {
          // The name of the backend origin
          name: "origin",
    
          // Use the following to override the host header sent from the browser when connecting to the origin
          override_host_header: "swapi-elixir.fly.dev",
    
          // The list of origin hosts to which to connect
          hosts: [
            {
              // The domain name or IP address of the origin server
              location: "swapi-elixir.fly.dev",
            },
          ],
    
          tls_verify: {
            use_sni: true,
            sni_hint_and_strict_san_check: "swapi-elixir.fly.dev",
          },
    
          // Uncomment the following to configure a shield
          shields: {
            "emea": "FRB",
            "us_west": "LAA"
          }
    
        },
      ],
    },
  },

  // Options for hosting serverless functions on Edgio
  // serverless: {
  //   // Set to true to include all packages listed in the dependencies property of package.json when deploying to Edgio.
  //   // This option generally isn't needed as Edgio automatically includes all modules imported by your code in the bundle that
  //   // is uploaded during deployment
  //   includeNodeModules: true,
  //
  //   // Include additional paths that are dynamically loaded by your app at runtime here when building the serverless bundle.
  //   include: ['views/**/*'],
  // },

  // The maximum number of URLs that will be concurrently prerendered during deployment when static prerendering is enabled.
  // Defaults to 200, which is the maximum allowed value.
  // prerenderConcurrency: 200,

  // A list of glob patterns identifying which source files should be uploaded when running edgio deploy --includeSources.
  // This option is primarily used to share source code with Edgio support personnel for the purpose of debugging. If omitted,
  // edgio deploy --includeSources will result in all files which are not gitignored being uploaded to Edgio.
  //
  // sources : [
  //   '**/*', // include all files
  //   '!(**/secrets/**/*)', // except everything in the secrets directory
  // ],
};
