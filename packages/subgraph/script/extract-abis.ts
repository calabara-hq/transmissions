import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import {
    channelAbi,
    channelFactoryAbi,
    customFeesAbi,
    infiniteRoundAbi,
    logicAbi
} from "transmissions-protocol";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const abisPath = path.join(__dirname, "..", "abis");
if (!fs.existsSync(abisPath)) {
    fs.mkdirSync(abisPath);
}

function output_abi(abiName, abi) {
    fs.writeFileSync(
        path.join(abisPath, `${abiName}.json`),
        JSON.stringify(abi, null, 2),
    );
}

const main = () => {
    output_abi("Channel", channelAbi);
    output_abi("ChannelFactory", channelFactoryAbi);
    output_abi("CustomFees", customFeesAbi);
    output_abi("InfiniteRound", infiniteRoundAbi);
    output_abi("Logic", logicAbi);
}

main();