import ftp from "basic-ftp";
import fs from "fs";
import path from "path";

const FTP_HOST = "ftp.kaderpintar.id";
const FTP_PORT = 21;
const FTP_USER = "kaderpintarid@kaderpintar.id";
const FTP_PASS = "kaderpintarid";
const LOCAL_DIR = ".output/public";
const KEEP_FILES = [".well-known", "cgi-bin", "ftpquota", ".htaccess"];

async function deploy() {
    const client = new ftp.Client();
    client.ftp.verbose = true;

    try {
        console.log("Connecting to FTP...");
        await client.access({
            host: FTP_HOST,
            port: FTP_PORT,
            user: FTP_USER,
            password: FTP_PASS,
        });

        console.log("Fetching existing files...");
        const list = await client.list();
        for (const file of list) {
            if (!KEEP_FILES.includes(file.name)) {
                console.log(`Deleting ${file.name}...`);
                if (file.type === 2) {
                    await client.removeDir(file.name);
                } else {
                    await client.remove(file.name);
                }
            }
        }

        console.log("Uploading new files...");
        await client.uploadFromDir(LOCAL_DIR);

        console.log("Deployment complete!");
    } catch (err) {
        console.error("Deployment failed:", err);
    } finally {
        client.close();
    }
}

deploy();
