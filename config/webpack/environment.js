const { environment } = require("@rails/webpacker");

environment.config.set("node", false);

module.exports = environment;
