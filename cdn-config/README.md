## EDGIO CDN Configuration

This file is the configuration of our CDN. 

To deploy any changes to edgio configuration. 
1. Run `npm i` to install dependencies
2. Do changes to the `edgio.config.js` or `routes.js`
3. Run `npx edg deploy`

We have two enviroments:
- `production`
- `dev`

CND Configurations are automatically deployed in the CI/CD
