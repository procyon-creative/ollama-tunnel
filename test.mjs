import 'dotenv/config';
import { readFileSync, existsSync } from 'fs';
import { createOpenAICompatible } from '@ai-sdk/openai-compatible';
import { streamText } from 'ai';

const isLocal = process.argv.includes('--local');

const headers = {};

// Load Cloudflare Access credentials from the shared volume
if (!isLocal) {
  const credsPath = process.env.ACCESS_CREDENTIALS_FILE || './access-credentials.json';
  if (existsSync(credsPath)) {
    const creds = JSON.parse(readFileSync(credsPath, 'utf-8'));
    headers['CF-Access-Client-Id'] = creds.client_id;
    headers['CF-Access-Client-Secret'] = creds.client_secret;
    console.log(`Loaded Access credentials from ${credsPath}`);
  } else {
    console.log(`No credentials file at ${credsPath} — connecting without Access auth`);
  }
}

const ollama = createOpenAICompatible({
  name: 'ollama',
  baseURL: isLocal
    ? 'http://localhost:11434/v1'
    : `https://${process.env.OLLAMA_HOSTNAME}/v1`,
  apiKey: 'unused',
  headers,
});

const model = ollama(process.env.OLLAMA_MODEL || 'tinyllama');

const { textStream } = streamText({
  model,
  prompt: 'Explain quantum tunneling in one paragraph.',
});

for await (const chunk of textStream) {
  process.stdout.write(chunk);
}
console.log();
