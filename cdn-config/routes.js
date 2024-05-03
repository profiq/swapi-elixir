
import { Router, edgioRoutes } from '@edgio/core'


// Edgio automatically respects all cache headers, we don't have to setup anything here.

export default new Router()
  // Redirect HTTP to HTTPS
  .match({
      scheme: "HTTP",
  }, ({ setResponseHeader, setResponseCode }) => {
      setResponseHeader("Location", "https://%{host}%{normalized_uri}")
      // Change to 301 when you see the correct redirect on your site
      setResponseCode(302)
  })

  // https://developer.chrome.com/blog/private-prefetch-proxy/
  .match("/.well-known/traffic-advice", ({ send, setResponseHeader, cache }) => {
    setResponseHeader("Content-Type", "application/trafficadvice+json");
    send('[{"user_agent": "prefetch-proxy","fraction": 1.0}]', 200);
    cache({
      edge: {
        maxAgeSeconds: 60 * 60 * 24,
        staleWhileRevalidateSeconds: 60 * 60 * 24 * 7,
        forcePrivateCaching: true,
      },
    });
  })

  .match('/', ({ setComment }) => {
    setComment("Homepage")
  })

  .match('/swaggerui', ({ setComment }) => {
    setComment("Swagger UI")
  })

  .match('/postman', ({ setComment }) => {
    setComment("Postman")
  })
  
  .match('/api/:path*', ({ setComment }) => {
    setComment("API route")
  })


  // Here is an example where we cache api/* at the edge but prevent caching in the browser
  // .match('/api/:path*', {
  //   caching: {
  //     max_age: '1d',
  //     stale_while_revalidate: '1h',
  //     bypass_client_cache: true,
  //     service_worker_max_age: '1d',
  //   },
  // })

  // Here is an example of how to specify an edge function to run for a particular path
  // .get('/', {
  //   edge_function: './edge-functions/main.js',
  //   caching: {
  //     max_age: '1d', // optionally cache the output of the edge function for 1 day
  //   }
  // })

  // plugin enabling basic Edgio functionality
  .use(edgioRoutes)
