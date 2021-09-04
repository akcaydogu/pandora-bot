const { Client, Discord, MessageEmbed, Collection } = require("discord.js");
const { config } = require("dotenv");
const DisTube = require("distube");
const fs = require('fs');
const { spawn } = require('child_process');


const prefix2 = "!";

const client = new Client({
	disableEveryone: true
});

const distube = new DisTube(client, { searchSongs: true, emitNewSongOnly: true });

//const { Player } = require("discord-music-player");
// Create a new Player (Youtube API key is your Youtube Data v3 key)
//const player = new Player(client, "AIzaSyAn6Xr2iUtFdceOxjZvFVTd2sw-idavqCo");
// To easily access the player
//client.player = player;


config({
	path: __dirname + "/.env"
});


var mysql = require('mysql');

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "test"
});

con.connect(function(err) {
	if (err) throw err;
	console.log("Connected!");
  });

client.on("guildCreate", guild => {
	var sql = `INSERT INTO guild (id, prefix, lang) VALUES ('${guild.id}', '!', 'en')`;
	con.query(sql, function (err, result) {
	  if (err) throw err;
	  console.log("1 record inserted");
	});
})

client.on("guildDelete", guild => {
	console.log("Left a guild: " + guild.name);
	var sql = `DELETE FROM guild WHERE id = '${guild.id}'`;
	con.query(sql, function (err, result) {
	  if (err) throw err;
	  console.log("Number of records deleted: " + result.affectedRows);
	});
})

client.on('ready', () => {
	console.log(`Hi, ${client.user.username} is now online!`);
	console.log(`Hi i am online at ${client.guilds.cache.size} server!`);

	client.user.setActivity("Albion Online", {
		type: "STREAMING",
		url: "https://www.twitch.tv/pandorabotdiscord"
	});
})

client.on("message", async (message) => {

	con.query(`SELECT * FROM guild WHERE id = '${message.guild.id}'`, function (err, result, fields) {
		if (err) throw err;
		let prefix = result[0].prefix;
		let lang = result[0].lang;
		codeX(prefix, lang);
	});

	async function codeX(prefix, lang){

		if (message.author.bot) return;
		if (!message.guild) return;
		if (!message.content.startsWith(prefix)) return;

		var user = client.users.cache.get("351395168588660746");
		const args = message.content.slice(prefix.length).trim().split(/ +/g);
		const cmd = args.shift().toLowerCase();

		// Queue status template
		const status = (queue) => `Volume: \`${queue.volume}%\` | Filter: \`${queue.filter || "Off"}\` | Loop: \`${queue.repeatMode ? queue.repeatMode == 2 ? "All Queue" : "This Song" : "Off"}\` | Autoplay: \`${queue.autoplay ? "On" : "Off"}\``;

		// DisTube event listeners, more in the documentation page
		distube
			.on("playSong", (message, queue, song) => message.channel.send(
				`Playing \`${song.name}\` - \`${song.formattedDuration}\`\nRequested by: ${song.user}\n${status(queue)}`
			))
			.on("addSong", (message, queue, song) => message.channel.send(
				`Added ${song.name} - \`${song.formattedDuration}\` to the queue by ${song.user}`
			))
			.on("playList", (message, queue, playlist, song) => message.channel.send(
				`Play \`${playlist.name}\` playlist (${playlist.songs.length} songs).\nRequested by: ${song.user}\nNow playing \`${song.name}\` - \`${song.formattedDuration}\`\n${status(queue)}`
			))
			.on("addList", (message, queue, playlist) => message.channel.send(
				`Added \`${playlist.name}\` playlist (${playlist.songs.length} songs) to queue\n${status(queue)}`
			))
			// DisTubeOptions.searchSongs = true
			.on("searchResult", (message, result) => {
				let i = 0;
				message.channel.send(`**Choose an option from below**\n${result.map(song => `**${++i}**. ${song.name} - \`${song.formattedDuration}\``).join("\n")}\n*Enter anything else or wait 60 seconds to cancel*`);
			})
			// DisTubeOptions.searchSongs = true
			.on("searchCancel", (message) => message.channel.send(`Searching canceled`))
			.on("error", (message, e) => {
				console.error(e)
				message.channel.send("An error encountered: " + e);
			});

		if (cmd === "help"){
			const helpEmbed = new MessageEmbed()
				.setTitle("Test")
				
			message.channel.send(helpEmbed);
		}

		if (cmd === "te"){
			const ls = spawn('npm', ['update',args[0],'--save-prod']);
			
			ls.stdout.on('data', (data) => {
			  console.log(`stdout: ${data}`);
			});
			
			ls.stderr.on('data', (data) => {
			  console.error(`stderr: ${data}`);
			});
			
			ls.on('close', (code) => {
			  console.log(`child process exited with code ${code}`);
			});
		}

		if (cmd === "botinfo"){
			const exampleEmbed = new MessageEmbed()
				.setColor(3066993)
				.setThumbnail(client.user.displayAvatarURL())
				.setTitle("🛠️ Pandora Bot Bilgileri")
				.setDescription("Bu bot henüz test aşamasındadır.")
				.setFooter("Developer : Doğukan#1611",user.displayAvatarURL());
			message.channel.send(exampleEmbed);
		}

		if (cmd === "serverinfo"){
			const exampleEmbed = new MessageEmbed()
				.setColor(3066993)
				.setTitle("Server Info")
				.setThumbnail(message.guild.displayAvatarURL)
				.setDescription(`${message.guild}'s information`)
				.addField("Bot Language : ", `${lang}`)
        	message.channel.send(exampleEmbed);	
		}

		if (cmd === "ping2"){
			const msg = await message.channel.send(`Pinging....`);
			const exampleEmbed = new MessageEmbed()
				.setColor(3066993)
				.addField(`⌛ Gecikme`, `${Math.floor(msg.createdTimestamp - message.createdTimestamp)}ms`)
				.addField("⏱️ API Gecikme", `${Math.round(client.ws.ping)}`);
			message.channel.send(exampleEmbed);
			msg.delete({ timeout: `${Math.floor(msg.createdTimestamp - message.createdTimestamp)}ms` })
		}

		if (cmd === "invite"){
			const exampleEmbed = new MessageEmbed()
				.setColor(3066993)
				.setTitle("Invite")
				.addField("Click", " [Invite](https://discord.com/oauth2/authorize?client_id=740322854058459217&scope=bot&permissions=8)")
				.setThumbnail(client.user.displayAvatarURL())
        	message.channel.send(exampleEmbed);	
		}

		if (cmd === "lang"){
			if (message.member.hasPermission("MANAGE_GUILD")) {
				if (!args.length){
					if (lang === "en"){
						return message.channel.send("You should enter argument.");
					} else if (lang === "tr"){
						return message.channel.send("Bir argüman girmelisin.");
					}
				} else {
					if (args[0] === lang){
						if(lang === "en") {
							return message.channel.send("This language already selected");
						} else if (lang === "tr"){
							return message.channel.send("Zaten bu dil seçili");
						}
					} else if (args[0] === "en"){
						var sql = `UPDATE guild SET lang = '${args[0]}' WHERE id = '${message.guild.id}'`
						con.query(sql, function (err, result){
							if (err) throw err;
							console.log("Dil değiştirildi");
							message.channel.send(`Language changed to English`);
						});
					} else if (args[0] === "tr"){
						var sql = `UPDATE guild SET lang = '${args[0]}' WHERE id = '${message.guild.id}'`
						con.query(sql, function (err, result){
							if (err) throw err;
							console.log("Dil değiştirildi");
							message.channel.send(`Dil Türkçeye çevrildi`);
						});
					}
				}
			} else {
				if (lang === "en") {
					message.channel.send("You don't have enough permission.");
				} else if (lang === "tr"){
					message.channel.send("Yeterli yetkiniz yok.");
				}
			}

		}

		if (cmd === "skip"){
			distube.skip(message)
			if (lang === "en"){
				return message.channel.send(`skipped!`);
			} else if (lang === "tr"){
				return message.channel.send(`geçildi!`);
			}
		}

		if (cmd === "queue"){
			let queue = distube.getQueue(message);
			message.channel.send('Current queue:\n' + queue.songs.map((song, id) =>
				`**${id + 1}**. ${song.name} - \`${song.formattedDuration}\``
			).slice(0, 10).join("\n"));
		}

		if ([`3d`, `bassboost`, `echo`, `karaoke`, `nightcore`, `vaporwave`, `reverse`, `phaser`, `mcompand`].includes(cmd)) {
			let filter = distube.setFilter(message, cmd);
			message.channel.send("Current queue filter: " + (filter || "Off"));
		}

		if (cmd === "volume"){
			distube.setVolume(message);
		}

		if (cmd === "play"){
			if(!args.length){
				if (lang === "en"){
					return message.channel.send("Please enter a song name.")
				} else if (lang === "tr"){
					return message.channel.send("Lütfen bir şarkı adı yazınız.")
				}
			} else {
				var muzik = message.content.slice(6)
				distube.play(message, args.join(" "));
			}


		}


		if (cmd === "prefix"){
			if (!args.length){
				if (lang === "tr"){
					return message.channel.send("Bir prefix girmelisin.");
				} else if (lang === "en") {
					return message.channel.send("You should enter prefix");
				}

			}
			else {
				if (message.member.hasPermission("MANAGE_GUILD")){
					var sql = `UPDATE guild SET prefix = '${args[0]}' WHERE id = '${message.guild.id}'`
					con.query(sql, function (err, result){
						if (err) throw err;
						console.log("Prefix değişti");
						if (lang === "en"){
							message.channel.send(`Prefix changed to ${args[0]}`);
						} else if (lang === "tr"){
							message.channel.send(`Prefix ${args[0]} olarak değiştirildi.`);
						}
					});
				} else {
					if (lang === "en") {
						message.channel.send("You don't have enough permission.");
					} else if (lang === "tr"){
						message.channel.send("Yeterli yetkiniz yok.");
					}
				}
			}


		}

		if (cmd === "muteall") {
			if (args[0] === "1"){
				let channel = message.guild.channels.cache.get(message.member.voice.channel.id);
				for (const [memberID, member] of channel.members) {
					member.voice.setMute(true);
			}
	
			} else if (args[0] === "2"){
				let channel = message.guild.channels.cache.get(message.member.voice.channel.id);
				for (const [memberID, member] of channel.members) {
					member.voice.setMute(false);
			}
			} else {
				message.channel.send(`!muteall 1 Tüm kanalı mutelar. !muteall 2 Tüm kanalın mutesini açar`);
			}
		}
	}
});

client.login(process.env.TOKEN);
