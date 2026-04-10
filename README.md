# ollama-tunnel

Run ollama behind a Cloudflare Tunnel with API key auth. Expose your local or remote GPU to any OpenAI-compatible client (Brave Leo, Continue, LiteLLM, etc.) with just a URL and API key.

Uses [cloudflare-tunnel-init](https://github.com/procyon-creative/cloudflare-tunnel-init) for automated tunnel setup.

## Quick start

**1. Clone and configure:**

```sh
git clone git@github.com:procyon-creative/ollama-tunnel.git
cd ollama-tunnel
cp .env.example .env
cp tunnel-config.example.json tunnel-config.json
```

Edit `.env` with your Cloudflare credentials and desired API key. Edit `tunnel-config.json` with your hostname.

**2. Start:**

```sh
docker compose up -d
```

**3. Use it:**

- **URL:** `https://your-hostname.example.com/v1/chat/completions`
- **API key:** whatever you set in `API_KEY`
- **Model:** any model available in ollama (e.g. `tinyllama`, `qwen3:30b`, `gemma4:26b`)

## GPU support

The compose file sets `NVIDIA_VISIBLE_DEVICES=all`. On Linux with the NVIDIA Container Toolkit, set the nvidia runtime as default:

```sh
sudo nvidia-ctk runtime configure --runtime=docker --set-as-default
sudo systemctl restart docker
```

After that, `docker compose up -d` uses the GPU automatically. On Mac, the env var is ignored and ollama runs on CPU. Same command everywhere.

## Using host models

By default, ollama stores models in a local `.ollama-data/` directory. To share models already pulled on the host:

```env
OLLAMA_DATA=/usr/share/ollama/.ollama
```

This bind-mounts the host's model directory into the container.

## Shell integration

Wrap the `ollama` CLI to run through docker compose transparently:

```sh
./scripts/shell-setup.sh install
source ~/.zshrc  # or ~/.bashrc
```

Then use ollama as normal:

```sh
ollama list
ollama pull qwen3:30b
ollama run tinyllama
ollama ps
```

Services auto-start if not running.

## Environment variables

| Variable               | Required | Default          | Description |
|------------------------|----------|------------------|-------------|
| `CLOUDFLARE_API_TOKEN` | Yes      |                  | Cloudflare API token |
| `CLOUDFLARE_ACCOUNT_ID`| Yes      |                  | Cloudflare account ID |
| `CLOUDFLARE_ZONE_ID`   | Yes      |                  | Zone ID for DNS |
| `TUNNEL_NAME`          | Yes      |                  | Name for the tunnel |
| `API_KEY`              | No       |                  | Bearer token for API key auth |
| `OLLAMA_MODEL`         | No       | `tinyllama`      | Model to pull on first start |
| `OLLAMA_DATA`          | No       | `.ollama-data`   | Path to ollama data directory |

## Testing

```sh
# Via curl
./test-curl.sh

# Via AI SDK
npm install
npm run test:local    # direct to localhost
npm test              # through the tunnel
```

## License

MIT
