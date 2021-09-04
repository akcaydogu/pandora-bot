const { Client, Discord, MessageEmbed, Collection } = require("discord.js");

const client = new Client({
	disableEveryone: true
});

module.exports = {
    name: 'ping',
    description: 'Ping Command',
    async execute(message, args) {	
        const msg = await message.channel.send(`Pinging....`);
        const exampleEmbed = new MessageEmbed()
            .setColor(3066993)
            .addField(`⌛ Gecikme`, `${Math.floor(msg.createdTimestamp - message.createdTimestamp)}ms`)
            .addField("⏱️ API Gecikme", `${Math.round(client.ws.ping)}`);
        message.channel.send(exampleEmbed);
        msg.delete({ timeout: `${Math.floor(msg.createdTimestamp - message.createdTimestamp)}ms` })
    },
};