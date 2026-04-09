import 'dotenv/config';
import { createOpenAICompatible } from '@ai-sdk/openai-compatible';
import { streamText } from 'ai';

const isLocal = process.argv.includes('--local');

const ollama = createOpenAICompatible({
  name: 'ollama',
  baseURL: isLocal
    ? 'http://localhost:11434/v1'
    : `https://${process.env.OLLAMA_HOSTNAME}/v1`,
  apiKey: isLocal ? 'unused' : process.env.API_KEY,
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
