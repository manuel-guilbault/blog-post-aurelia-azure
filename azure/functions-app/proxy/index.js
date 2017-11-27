const http = require('http');
const path = require('path');
const { parse: parseUrl, format: formatUrl } = require('url');

module.exports = function(context, request) {
  const pathname = context.bindingData.path || '';
  const backendUrl = getBackendUrl(pathname);

  sendGetRequest(backendUrl, (error, response) => {
    if (error) {
      context.log.error(`Request to ${backendUrl} failed: ${error}`);
      context.done(null, { status: 500 });

    } else if (response.status === 404) {
      const indexUrl = getBackendUrl('index.html');
  
      sendGetRequest(indexUrl, (error, response) => {
        if (error) {
          context.log.error(`Request to ${indexUrl} failed: ${error}`);
          context.done(null, { status: 500 });
        } else {
          context.log.info(`Request to ${indexUrl} returned ${response.statusCode}`);
          context.done(null, response);
        }
      });

    } else {
      context.done(null, response);
    }
  });
};

function getBackendUrl(pathname) {
  const storageHostAndPath = process.env['Storage.HostAndContainer'];
  const sasToken = process.env['Storage.SasToken'];

  if (pathname === '') {
    pathname = 'index.html';
  }

  const hostAndPath = path.posix.join(storageHostAndPath, pathname);
  const rawUrl = `http://${hostAndPath}${sasToken}`;
  return parseUrl(rawUrl);
}

function sendGetRequest(uri, callback) {
  const options = {
    protocol: uri.protocol,
    hostname: uri.hostname,
    port: uri.port,
    path: uri.path,
  };
  const request = http.get(options, (response) => { toAzureFunctionsResponse(response, callback); });
  request.on('error', (e) => { callback(e, null); });
  request.end();
}

function toAzureFunctionsResponse(response, callback) {
  const azureFunctionsResponse = {
    status: response.statusCode,
    headers: response.headers,
    body: ''
  };
  response.on('error', (error) => { callback(error, null); });
  response.on('data', (chunk) => {
    azureFunctionsResponse.body += chunk;
  });
  response.on('end', () => {
    callback(null, azureFunctionsResponse);
  });
}
