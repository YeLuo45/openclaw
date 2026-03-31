// Defaults for agent metadata when upstream does not supply them.
// Primary default: Alibaba Qwen (portal OAuth / compatible API).
export const DEFAULT_PROVIDER = "qwen-portal";
export const DEFAULT_MODEL = "coder-model";
// Qwen Portal coder-model context window (see models-config.providers.ts).
export const DEFAULT_CONTEXT_TOKENS = 128_000;
