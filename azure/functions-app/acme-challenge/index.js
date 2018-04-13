const fs = require('fs');

module.exports = function(context, request) {
  const responseFilePath = `D:\\home\\site\\wwwroot\\.well-known\\acme-challenge\\${context.bindingData.code}`;

  context.log(`Checking for ACME challenge response at '${responseFilePath}'...`);

  fs.exists(responseFilePath, (exists) => {
    if (!exists) {
      context.log(`ACME challenge response file '${responseFilePath}' not found.`);
      context.done(null, {
        status: 404,
        headers: { "Content-Type": "text/plain" },
        body: 'ACME challenge response not found.'
      });
      return;
    }

    context.log(`ACME challenge response file '${responseFilePath}' found. Reading file...`);
    fs.readFile(responseFilePath, (error, data) => {
      if (error) {
        context.log.error(`An error occured while reading file '${responseFilePath}'.`, error);
        context.done(null, { status: 500 });
        return;
      }

      context.log(`ACME challenge response file '${responseFilePath}' read successfully.`);
      context.done(null, {
        status: 200,
        headers: { "Content-Type": "text/plain" },
        body: data
      });
    });
  });
};
