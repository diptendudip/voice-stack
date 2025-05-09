import WebSocket from "ws";
import { execFileSync } from "child_process";
import fs from "fs";
import path from "path";

export async function transcribeStream(rtpStream) {
  return new Promise((resolve, reject) => {
    const ws = new WebSocket(process.env.DG_URL, {
      headers: { Authorization: `Token ${process.env.DG_KEY}` }
    });
    let finalText = "";
    ws.on("open", () => rtpStream.pipe(ws));
    ws.on("message", m => {
      const { channel: { alternatives: [alt] } } = JSON.parse(m);
      if (alt?.transcript) finalText = alt.transcript;
    });
    ws.on("close", () => resolve(finalText));
    ws.on("error", reject);
  });
}

export async function synthesize(text) {
  const tmp = path.join("/tmp", `tts_${Date.now()}.wav`);
  execFileSync("/usr/local/bin/piper", [
    "--model", process.env.PIPER_MODEL,
    "--output_file", tmp
  ], { input: text });
  return fs.readFileSync(tmp);
}

console.log("Orchestrator ready");
