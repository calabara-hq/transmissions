import { defineConfig } from "@wagmi/cli";
import { foundry } from "@wagmi/cli/plugins";

export default defineConfig({
  out: "package/index.ts",
  plugins: [
    foundry({
      forge: {
        build: false,
      },
      include: [
        "ChannelFactory",
        "Channel",
        "CustomFees",
        "InfiniteRound",
        "Logic",
        "UpgradeGate",
      ].map((contractName) => `${contractName}.json`),
    }),
  ],
});
