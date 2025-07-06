# ARZYG — A Token Born from Verified Usefulness 🌐🤖

ARZYG is the **first token standard of Web4**, where value is **not mined, farmed, or traded for hype** — it's **born** from real-world usefulness, confirmed by AI.

---

## 🌍 Why Web4?

> Web3 gave us ownership.  
> **Web4 gives us meaning.**

In Web4, tokens appear only when **work is done** and **verified** — by intelligent systems, not just human input.

ARZYG is **born from usefulness**.  
No proof = no token.

---

## 🔐 Key Innovations

| Feature                     | Description                                                       |
|----------------------------|-------------------------------------------------------------------|
| ✅ ERC-20 Backbone          | Based on secure OpenZeppelin standards                            |
| 🤖 AI Oracle (Chainlink)    | Minting only after usefulness proof is validated by AI            |
| 🔁 On-chain + Off-chain     | Full Circle: Proof → AI → Chainlink → Token                       |
| 🛠 AccessControl            | Roles: Admin, Reserve, Oracle                                     |
| 📡 Chainlink Functions      | Verifies usefulness via external server/API                       |
| 🔥 `requestAIMint()`        | Calls AI from smart contract and awaits confirmation              |

---

## ⚙️ How It Works (Web4 Flow)

1. 🌱 Employer reserves a parent token  
2. 👷 Worker completes a task in the real world  
3. 📄 Proof is sent to an **AI server**  
4. 🤖 AI verifies the proof via **Chainlink Functions**  
5. 💎 A child token (ARZYG) is **born** on-chain  
6. 🔁 The parent reserve burns itself — balance remains fair

---

## 🧠 Smart Contract

Latest: [`ARZYG_ERC20_AI.sol`](contracts/ARZYG_ERC20_AI.sol)

Supports:
- `requestAIMint(proof, to, amount)` — Calls Chainlink Functions for AI verification
- `fulfillRequest()` — Receives callback and mints only if AI approved
- `AccessControl` for admin/reserve/oracle logic
- `ProofRejected` and `AIMinted` events for transparency

---

## 🧪 Try It Live

Coming soon:

- Web demo with proof submission + real Chainlink verification
- Public AI scoring endpoint for usefulness (OpenAI or Hugging Face)

---

## 💬 Join the Idea

- Twitter: [@Arzykulm](https://twitter.com/Arzykulm)
- Email: arzukul9977@gmail.com
- Site: [arzy-g.com](https://arzy-g.com)
- GitHub: [github.com/arzyk](https://github.com/arzykul)

---

## 📜 License

MIT — open to all who build for usefulness.

Made with ❤️ in Kyrgyzstan by [Arzykul Muratov](https://github.com/arzykul)
