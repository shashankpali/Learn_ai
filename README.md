# Learn AI – Hands-on project

Two projects (Flutter + iOS) for the **AI-Enabled Mobile Engineer** learning path. Use this README as the single source of truth for the path and current step.

**Learning goals:** (1) **AI integration** — streaming, prompts, APIs, UX. (2) **Design patterns** — applied in code and documented here so the project doubles as a patterns reference. (3) **Scalability** — structure and patterns chosen so the app can grow (new features, state, multiple providers) without rewrites.

---

## For a new chat / new window

**To continue this learning project**, you can say something like:

> "Continue the AI mobile learning project. Follow the path in @learn_ai/README.md (or @/Users/apple/Desktop/Project/learn_ai/README.md). We're at the step marked **Current step** below."

The AI will use this file to know the goal, the path, and where to continue.

---

## Execution order

**Complete the Flutter project first (all phases through Phase 5), then bring the iOS project to the same level.** Do not implement the same phase in both platforms in parallel. This keeps focus, avoids context-switching, and lets iOS benefit from patterns and decisions established in Flutter.

---

## Code & architecture standards

As part of this exercise, use **latest stable frameworks, clear design patterns, and consistent coding style** so the codebase doubles as a reference for modern mobile development.

**Flutter / Dart**

- **SDK:** Dart 3.x, Flutter 3.x; target latest stable.
- **Style:** Effective Dart (official guidelines), `flutter_lints` (or project lints). Prefer `const` constructors, null safety, strong typing.
- **Architecture:** Separate UI from business logic. Use a clear abstraction for “AI streaming” (e.g. interface/abstract class) so fake and real implementations are swappable. Prefer small, testable units (services/repositories for API, widgets for UI). Consider `Stream`/`Future`-based APIs for streaming and async.
- **UI:** Material 3 (`useMaterial3: true`), responsive layout, accessible labels where relevant.

**iOS / Swift (when we get there)**

- **SDK:** Current Xcode / Swift 6 where applicable; target latest stable.
- **Style:** Swift API Design Guidelines, SwiftLint if used in project. Prefer value types, `async`/`await`, structured concurrency.
- **Architecture:** Same idea as Flutter: abstraction for streaming (protocol), UI vs logic separation, small testable components.

**General**

- Dependencies: prefer official or widely adopted packages (e.g. HTTP client, no unnecessary bloat).
- Secrets: never commit API keys; use environment variables or a secure local config (e.g. `.env` ignored by git, or Xcode config).

---

## Design patterns we follow

| Pattern | What we use it for | Where in code (Flutter) |
|--------|---------------------|--------------------------|
| **Strategy (abstraction)** | Swap fake vs real streaming without changing UI. | `core/domain/ai_streamer.dart` (contract); `features/streaming/data/fake_ai_streamer.dart` (impl). |
| **Dependency injection (constructor)** | Inject streamer into screen and app; testable, decoupled. | `StreamingScreen(streamer:)`, `LearnAIApp(aiStreamer:)`. |
| **Composition root** | Single place that creates dependencies and wires the app. | `main.dart` — builds `FakeAIStreamer()`, passes to `LearnAIApp`. |
| **Separation of concerns** | UI only in presentation; data/domain in their layers. | `features/streaming/presentation/` vs `data/` vs `core/domain/`. |
| **Reactive streams** | Streaming responses as `Stream<String>`; UI subscribes per chunk. | `AIStreamer.streamResponse()`; screen `.listen()`. |
| **Single responsibility** | One file, one reason to change. | Each layer and screen in its own file; `main` vs `app` vs features. |


We avoid: massive controllers, logic inside widgets, and tight coupling to a concrete API. Phase 2 adds a **data-layer** implementation of `AIStreamer` (e.g. OpenAI) without changing the contract or the screen.

---

## Scalability (how we grow without rewrites)

- **Feature-based layout:** `lib/core/` (shared contracts, e.g. `AIStreamer`), `lib/features/<feature>/` (data + presentation). New features = new folder (e.g. `features/chat_history/`, `features/settings/`). No big "screens" or "services" dump.
- **Single composition root:** `main.dart` creates all top-level dependencies and passes them in. When we add config, real API, or state, we add them there (or a small `injection.dart`) and pass down. Later we can introduce a DI package (e.g. `get_it`, `provider`) without changing the pattern — still inject via constructor for testability.
- **State:** Today UI state is local (`setState`). When we need cross-screen or shared state (e.g. chat history, user prefs), we add a dedicated state layer (e.g. a notifier or BLoC) that the screen listens to; the streaming abstraction stays the same. No need to change `AIStreamer` or the screen's contract.
- **New data sources:** New AI provider = new class implementing `AIStreamer` in `features/streaming/data/`. Composition root (or config) chooses which one to inject. Same UI, same contract.

---

## Stability & code quality (in terms of “future ready”)

We treat **stability** and **code quality** as the foundation so the codebase can hold up as features and scale grow. No claim here about backend or 10M DAU infra — only that the **app code** is written and checked for reliability and maintainability.

**What we do today:**

| Area | Practice |
|------|----------|
| **Async safety** | Subscription cancelled in `dispose()`. Stream callbacks guard with `if (!mounted) return` before `setState` so we never update after unmount. |
| **Linting** | `flutter_lints` (include `flutter.yaml`); `flutter analyze` clean. |
| **Null safety** | Full null safety; strong typing. |
| **Structure** | Clear layers (core/domain, features/…/data, presentation); single composition root; no logic in widgets beyond local state and calling injected services. |
| **Tests** | Smoke test for streaming screen; app builds and runs. Unit tests for streamers and error paths can be added as we add real API (Phase 2) and error handling (Phase 3). |

**What we’ll add as we go:**

- **Phase 3:** Error handling, timeouts, retries, loading/skeleton — improves runtime stability and UX.
- **As needed:** More unit tests (e.g. `FakeAIStreamer`, cancel behavior, error propagation), and optionally stricter `analysis_options.yaml` or custom lints.

So **in terms of stability and code quality**: the project is in good shape for a learning codebase that’s meant to be future-ready — patterns and guards are in place; features and more tests will follow with the phases.

---

## Goal

**Become an AI-Enabled Mobile / Product Engineer** — i.e. a senior mobile engineer who can design and ship apps that include AI-driven features (API integration, streaming UX, prompts, error handling). Focus: **max salary growth + remote/consulting**. No ML theory or career switch; we extend the existing mobile stack.

**By the end of this path you will:**

- Integrate AI APIs into mobile apps (e.g. OpenAI, Anthropic).
- Handle **streaming responses** and update UI as chunks arrive.
- Design AI-driven UX (loading, streaming, retries, fallbacks).
- Work with prompts and simple structured outputs.
- Reason about when to call AI, latency, and cost vs UX.

---

## Learning path (overview)

| Phase | Focus | Flutter | iOS |
|-------|--------|---------|-----|
| **1** | AI foundations (mental model, streaming, no API yet) | ✅ Done | ✅ Done |
| **2** | Real AI API integration + streaming (same UI, real network) | 🔜 Next | Pending |
| **3** | Error handling, loading states, retries, fallbacks | Pending | Pending |
| **4** | AI UX patterns (multi-turn, structured output, cost/latency) | Pending | Pending |
| **5** | Polish + portfolio (something to show / say in interviews) | Pending | Pending |

**Approach:** Hands-on first (build → understand → refine). ~1 hour/day. No deep theory, no ML math. **Flutter is completed first (all phases), then iOS is brought to parity.**

---

## Current step

**Phase 1 is done** in both apps (Fake AI Streamer + simple UI with Start streaming / Cancel).

**Next:** Phase 2 for **Flutter only** — add **real AI API streaming**:

- Keep the same streaming UI (or refactor minimally for the new abstraction).
- Introduce a clear abstraction for “streaming provider” so fake and real are swappable (latest patterns, see Code & architecture standards).
- Implement real API call (e.g. OpenAI chat completions with `stream: true`), handle real latency, chunks, and connection.

After Flutter reaches Phase 5, repeat the path for iOS. When continuing in a new chat, start from Phase 2 Flutter unless the user says otherwise.

---

## Project structure

```
learn_ai/
├── README.md           # This file – path + current step
├── learn_ai_flutter/   # Flutter app (completed first, all phases)
│   └── lib/
│       ├── main.dart              # Composition root: create deps, runApp(LearnAIApp(aiStreamer:))
│       ├── app.dart               # LearnAIApp(aiStreamer), theme, home
│       ├── core/
│       │   └── domain/
│       │       └── ai_streamer.dart       # Contract (Strategy pattern)
│       └── features/
│           └── streaming/
│               ├── data/
│               │   └── fake_ai_streamer.dart  # Phase 1 impl
│               │   # Phase 2+: open_ai_streamer.dart etc.
│               └── presentation/
│                   └── streaming_screen.dart
└── learn_ai_ios/       # iOS app (brought to parity after Flutter)
    └── LearnAI/
        ├── LearnAIApp.swift
        ├── ContentView.swift
        └── FakeAIStreamer.swift
```

---

## Step 1 (done): Fake AI streamer

Both apps include:

- **FakeAIStreamer** – simulates an AI typing text character by character (no API, no keys).
- **UI** – Start streaming, watch the text build up, cancel mid-stream.

This established the streaming mental model and async UI updates before touching a real API.

---

## How to run

**Flutter**

```bash
cd /Users/apple/Desktop/Project/learn_ai/learn_ai_flutter
flutter pub get
flutter create .   # add platform folders if missing
flutter run
```

**iOS**

```bash
open /Users/apple/Desktop/Project/learn_ai/learn_ai_ios/LearnAI.xcodeproj
```

Then in Xcode: choose a simulator or device and press **Run** (⌘R).

---

## Phases in a bit more detail

- **Phase 1 (done):** Fake streamer + streaming mental model.
- **Phase 2 (next):** Real AI API (e.g. OpenAI), streaming endpoint, same UI; handle chunks and completion.
- **Phase 3:** Errors, timeouts, retries, loading/skeleton UI.
- **Phase 4:** Better prompts, optional structured output, simple cost/latency awareness.
- **Phase 5:** One clean “AI chat” (or similar) to show in portfolio / interviews.

---

*Last updated: Flutter-first order; Phase 2 next for Flutter only; code & architecture standards added for latest frameworks, design patterns, and coding style.*
