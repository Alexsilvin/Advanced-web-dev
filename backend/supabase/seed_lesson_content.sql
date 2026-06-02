-- ============================================================
--  EduSkills — Lesson Notes & Exercises Content
-- ============================================================
--  Adds real notes + exercises to all lessons in the 5 new
--  courses created by seed_extended.sql.
--
--  notes structure:
--    overview    — 2–3 sentence intro
--    keyPoints   — 4–5 actionable bullet points
--    codeExample — concrete snippet
--    deepDive    — nuance / common gotcha
--    summary     — one-sentence wrap-up
--
--  exercise structure:
--    title       — descriptive title
--    timeLimit   — minutes (≈ 20 % of lecture duration)
--    questions   — 3 MCQs, each with 4 options + explanation
-- ============================================================

BEGIN;

-- ============================================================
--  1. ADVANCED WEB DEVELOPMENT
-- ============================================================
UPDATE courses SET lessons = $awd$
[
  {
    "title": "Modern JavaScript: ES2022–2024 Feature Deep Dive",
    "duration": "75 min", "videoUrl": "",
    "description": "Deep dive into the latest ECMAScript features used in production codebases.",
    "notes": {
      "overview": "Modern JavaScript evolves through the TC39 proposal process. ES2022–2024 introduced private class fields, Array.at(), Object.hasOwn(), top-level await, logical assignment operators, the Temporal API, and Promise.withResolvers(). Understanding these features reduces boilerplate and prevents entire classes of runtime errors.",
      "keyPoints": [
        "Array.at(-1) replaces arr[arr.length-1] for readable negative-index access",
        "Nullish coalescing (??) only short-circuits on null/undefined — unlike || which also catches 0 and ''",
        "Private class fields (#balance) enforce true encapsulation without WeakMap workarounds",
        "Logical assignment (&&=, ||=, ??=) combines a guard condition and assignment into one expression",
        "Top-level await in ES modules eliminates async wrapper boilerplate in entry-point scripts"
      ],
      "codeExample": "// Private fields + static blocks (ES2022)\nclass BankAccount {\n  #balance = 0;\n  static #fee = 2;\n  deposit(n) { this.#balance += n - BankAccount.#fee; }\n  get balance() { return this.#balance; }\n}\n\n// Promise.withResolvers (ES2024)\nconst { promise, resolve, reject } = Promise.withResolvers();\nfetch('/api/data').then(r => r.json()).then(resolve).catch(reject);\nawait promise;",
      "deepDive": "Optional chaining (?.) short-circuits the entire expression — a?.b?.c() returns undefined without throwing even if a is null. However, this can silently swallow bugs: if you expect a method to always exist, a?.method() hiding a missing method is worse than a crash. Use optional chaining only when absence is a legitimate, expected state.",
      "summary": "Mastering these features makes code read like clear prose while removing whole categories of runtime TypeError."
    },
    "exercise": {
      "title": "Quiz: Modern JavaScript Features",
      "timeLimit": 15,
      "questions": [
        {
          "id": 1,
          "question": "What does [10, 20, 30].at(-1) return?",
          "options": ["10", "20", "30", "undefined"],
          "correct": 2,
          "explanation": "Array.at() supports negative indices where -1 means the last element. [10,20,30].at(-1) === 30."
        },
        {
          "id": 2,
          "question": "Which operator returns the right side ONLY when the left side is null or undefined (not 0 or '')?",
          "options": ["||", "&&", "??", "!"],
          "correct": 2,
          "explanation": "The nullish coalescing operator (??) treats only null and undefined as nullish. Unlike ||, it does NOT trigger on falsy values like 0, '', or false."
        },
        {
          "id": 3,
          "question": "What is logged? let x = 5; x &&= 10; console.log(x);",
          "options": ["5", "10", "true", "false"],
          "correct": 1,
          "explanation": "Logical AND assignment (&&=) assigns the right side only if the left side is truthy. Since 5 is truthy, x becomes 10."
        }
      ]
    }
  },
  {
    "title": "TypeScript Mastery: Generics, Mapped Types, Conditional Types & Template Literal Types",
    "duration": "90 min", "videoUrl": "",
    "description": "Encode business rules in the type layer rather than at runtime.",
    "notes": {
      "overview": "TypeScript's type system is Turing-complete. Generics, mapped types, conditional types, and template literal types form four pillars that let you express complex constraints at compile time. The goal is to move bugs from production crashes to red squiggles in the editor — where they cost nothing to fix.",
      "keyPoints": [
        "Generic constraints <T extends HasId> prevent calling non-existent properties at compile time",
        "Mapped types { [K in keyof T]: Readonly<T[K]> } systematically transform every property in an interface",
        "Conditional types (T extends U ? X : Y) enable type-level branching and use 'infer' to extract inner types",
        "Template literal types combine string unions: type EventName = `on${Capitalize<Action>}`",
        "The 'satisfies' operator validates a value against a type while preserving the narrowest inferred literal type"
      ],
      "codeExample": "// Conditional type with infer\ntype Awaited<T> = T extends Promise<infer R> ? R : T;\n\n// Mapped type generating setters\ntype Setters<T> = {\n  [K in keyof T as `set${Capitalize<string & K>}`]: (v: T[K]) => void;\n};\n\n// satisfies\nconst palette = { red: [255,0,0], blue: '#0000ff' } satisfies Record<string, string|number[]>;",
      "deepDive": "The never type is TypeScript's bottom type — a value that can never exist. When you use never in a discriminated union's default/else branch, TypeScript will give a compile error if you ever add a new union member without handling it. This 'exhaustiveness check' pattern is the most powerful use of never.",
      "summary": "Advanced TypeScript turns runtime surprises into compile-time guarantees, making large refactors safe and confident."
    },
    "exercise": {
      "title": "Quiz: TypeScript Advanced Types",
      "timeLimit": 18,
      "questions": [
        {
          "id": 1,
          "question": "What does Partial<T> produce?",
          "options": ["Makes all properties required", "Makes all properties optional", "Removes readonly from all properties", "Picks a subset of properties"],
          "correct": 1,
          "explanation": "Partial<T> is a built-in mapped type { [K in keyof T]?: T[K] } that makes every property optional by appending '?'."
        },
        {
          "id": 2,
          "question": "What is the resolved type of: type X = string extends object ? true : false;",
          "options": ["true", "false", "string | false", "boolean"],
          "correct": 1,
          "explanation": "string does not extend object in TypeScript's structural type system, so the conditional type evaluates to false."
        },
        {
          "id": 3,
          "question": "Which feature narrows a variable's type inside a conditional block?",
          "options": ["Generics", "Type assertion (as)", "Type guard (typeof / is predicate)", "Mapped types"],
          "correct": 2,
          "explanation": "Type guards — typeof, instanceof, or custom 'x is Type' predicates — tell TypeScript what the type must be within a branch, enabling safe property access."
        }
      ]
    }
  },
  {
    "title": "React 18 Internals: Fiber Architecture, Reconciliation & Concurrent Mode",
    "duration": "95 min", "videoUrl": "",
    "description": "Understand how React renders so you can reason about performance and edge cases.",
    "notes": {
      "overview": "React 18's Fiber architecture represents every element as a linked-list node ('fiber') that can be paused, resumed, and prioritised. Concurrent Mode exposes this scheduling capability to user code through features like Suspense, useTransition, and useDeferredValue. Understanding Fiber explains why rendering is now interruptible and how React avoids blocking the browser's main thread.",
      "keyPoints": [
        "Fiber splits rendering into two phases: the interruptible 'render' phase (reconciliation) and the synchronous 'commit' phase (DOM mutations)",
        "Automatic batching in React 18 groups all state updates — even inside setTimeout and fetch callbacks — into a single re-render",
        "useTransition marks a state update as non-urgent, keeping the UI responsive while computing the new state in the background",
        "useDeferredValue defers re-rendering a slow child component until the browser is idle, without adding a loading state",
        "StrictMode double-invokes effects in development to surface side-effects in cleanup functions that were previously hidden"
      ],
      "codeExample": "// useTransition keeps the input responsive while filtering a huge list\nconst [isPending, startTransition] = useTransition();\nconst [filter, setFilter] = useState('');\n\nfunction handleChange(e) {\n  // urgent: update the input immediately\n  setInputValue(e.target.value);\n  // non-urgent: filter 100k items in background\n  startTransition(() => setFilter(e.target.value));\n}",
      "deepDive": "The commit phase is synchronous and cannot be interrupted because it mutates the real DOM. This means all useLayoutEffect hooks run synchronously after DOM updates but before the browser paints. If you perform expensive calculations in useLayoutEffect you will block paint and degrade perceived performance — use useEffect for non-DOM work instead.",
      "summary": "Knowing Fiber's render/commit split lets you choose the right hook for every side-effect and understand why concurrent features cannot be adopted gradually without the new root API."
    },
    "exercise": {
      "title": "Quiz: React 18 Rendering Model",
      "timeLimit": 19,
      "questions": [
        {
          "id": 1,
          "question": "What is the key difference between the render phase and commit phase in React Fiber?",
          "options": [
            "Render phase mutates the DOM; commit phase computes the diff",
            "Render phase is interruptible; commit phase is synchronous and cannot be paused",
            "Render phase runs on a worker thread; commit phase runs on the main thread",
            "Render phase handles events; commit phase handles effects"
          ],
          "correct": 1,
          "explanation": "The render phase (reconciliation) computes what needs to change and can be interrupted by higher-priority work. The commit phase applies DOM mutations and runs effects synchronously — it cannot be paused."
        },
        {
          "id": 2,
          "question": "What does useTransition return?",
          "options": [
            "[isLoading, setLoading]",
            "[isPending, startTransition]",
            "[value, deferValue]",
            "[state, dispatch]"
          ],
          "correct": 1,
          "explanation": "useTransition returns [isPending, startTransition]. Wrap non-urgent state updates in startTransition() and use isPending to show a loading indicator."
        },
        {
          "id": 3,
          "question": "When does automatic batching in React 18 group state updates?",
          "options": [
            "Only inside React event handlers",
            "Only inside useEffect",
            "In React event handlers, setTimeout, fetch callbacks, and all other async contexts",
            "Only when useTransition is used"
          ],
          "correct": 2,
          "explanation": "React 18 automatic batching groups all state updates — regardless of where they happen — into a single re-render. React 17 only batched inside synthetic event handlers."
        }
      ]
    }
  },
  {
    "title": "Custom Hooks: Architecture, Composition Patterns & Avoiding Re-render Traps",
    "duration": "80 min", "videoUrl": "",
    "description": "Design reusable hooks that encapsulate side-effects cleanly.",
    "notes": {
      "overview": "Custom hooks are plain functions that start with 'use' and call other hooks. They are the primary abstraction mechanism in React — they replace class mixins, higher-order components, and render props for sharing stateful logic. Good custom hooks have a single responsibility, a stable API, and never expose internal implementation details.",
      "keyPoints": [
        "A custom hook's state is isolated per component instance — two components using the same hook have separate state",
        "Returning an object from a hook ({ data, loading, error }) is more extensible than returning an array",
        "Stabilise callback references with useCallback to prevent child re-renders caused by hook consumers",
        "useRef stores mutable values that survive re-renders without triggering them — ideal for timers, previous values, and DOM refs",
        "Always clean up subscriptions and timers in the useEffect return function to prevent memory leaks"
      ],
      "codeExample": "function useFetch(url) {\n  const [state, setState] = useState({ data: null, loading: true, error: null });\n  const abortRef = useRef(null);\n\n  useEffect(() => {\n    abortRef.current = new AbortController();\n    fetch(url, { signal: abortRef.current.signal })\n      .then(r => r.json())\n      .then(data => setState({ data, loading: false, error: null }))\n      .catch(err => { if (err.name !== 'AbortError') setState({ data: null, loading: false, error: err }); });\n    return () => abortRef.current.abort();\n  }, [url]);\n\n  return state;\n}",
      "deepDive": "Dependency arrays in useEffect are checked by reference equality for objects and arrays. If you pass an inline object { page: 1 } as a dependency, it creates a new reference on every render, causing an infinite effect loop. Stabilise dependencies with useMemo, or derive primitive values from objects before listing them in the dependency array.",
      "summary": "Well-designed custom hooks are the closest React equivalent to a library module — composable, testable, and hidden from the component tree."
    },
    "exercise": {
      "title": "Quiz: Custom Hooks & Effect Patterns",
      "timeLimit": 16,
      "questions": [
        {
          "id": 1,
          "question": "Two components both call useFetch('/api/users'). How many fetch requests are made?",
          "options": ["One shared request", "Two independent requests", "Zero — hooks are cached", "It depends on React version"],
          "correct": 1,
          "explanation": "Each component instance gets its own isolated copy of hook state. Two components using the same hook make two independent requests and maintain separate loading/data/error states."
        },
        {
          "id": 2,
          "question": "What is the purpose of returning a cleanup function from useEffect?",
          "options": [
            "To reset component state on unmount",
            "To cancel subscriptions, timers, or async operations before the next effect runs or the component unmounts",
            "To prevent the effect from running more than once",
            "To update the dependency array dynamically"
          ],
          "correct": 1,
          "explanation": "The cleanup function runs before the next effect execution and on unmount. Failing to clean up subscriptions or timers causes memory leaks and stale state updates on unmounted components."
        },
        {
          "id": 3,
          "question": "Why does passing { page: 1 } as a useEffect dependency cause an infinite loop?",
          "options": [
            "Objects cannot be used as dependencies",
            "Each render creates a new object reference, so React sees a new dependency every time",
            "useEffect does deep equality checks that always fail for objects",
            "page is a reserved property name in React"
          ],
          "correct": 1,
          "explanation": "useEffect compares dependencies with Object.is() (reference equality). A new object literal { page: 1 } is a new reference on every render, making React think the dependency changed and re-running the effect infinitely."
        }
      ]
    }
  },
  {
    "title": "Next.js 14 App Router: Layouts, Loading UI, Error Boundaries & Parallel Routes",
    "duration": "100 min", "videoUrl": "",
    "description": "Complete walkthrough of the App Router paradigm shift.",
    "notes": {
      "overview": "Next.js 14's App Router (app/) replaces the Pages Router with a file-system convention built on React Server Components. Every file in app/ is a Server Component by default. Special files — layout.tsx, page.tsx, loading.tsx, error.tsx, and not-found.tsx — map to React concepts automatically. Route groups ((folder)) organise routes without affecting URLs.",
      "keyPoints": [
        "layout.tsx wraps every page in that segment and persists across navigations without unmounting — perfect for sidebars and headers",
        "loading.tsx automatically wraps page.tsx in a Suspense boundary, showing a skeleton while the page's async data fetches",
        "error.tsx must be a Client Component ('use client') and receives the error and a reset() function to retry rendering",
        "Parallel routes (@slot) render two independent route segments in the same layout simultaneously — useful for dashboards with independent panels",
        "Intercepting routes (.) allow you to show a modal over the current page rather than navigating away — e.g. photo galleries"
      ],
      "codeExample": "// app/dashboard/layout.tsx\nexport default function DashboardLayout({ children, analytics }) {\n  // @analytics is a parallel route slot\n  return (\n    <div className=\"grid grid-cols-3\">\n      <Sidebar />\n      <main>{children}</main>\n      <aside>{analytics}</aside>\n    </div>\n  );\n}\n\n// app/dashboard/loading.tsx — auto Suspense boundary\nexport default function Loading() {\n  return <DashboardSkeleton />;\n}",
      "deepDive": "Because layout.tsx does not re-render on navigation between its children, you cannot read search params (useSearchParams) inside a layout — it would show stale values. Read dynamic data in page.tsx (which re-renders on every navigation) or use a Client Component with useSearchParams inside a Suspense boundary.",
      "summary": "The App Router replaces manual getServerSideProps wiring with a predictable file convention that makes data fetching co-located with the UI that needs it."
    },
    "exercise": {
      "title": "Quiz: Next.js 14 App Router",
      "timeLimit": 20,
      "questions": [
        {
          "id": 1,
          "question": "What React primitive does Next.js use automatically when you create a loading.tsx file?",
          "options": ["ErrorBoundary", "Suspense", "lazy()", "Transition"],
          "correct": 1,
          "explanation": "Next.js wraps the page.tsx (and its async data fetching) in a React Suspense boundary. loading.tsx is the fallback UI shown while the page's Promises resolve."
        },
        {
          "id": 2,
          "question": "Why must error.tsx be a Client Component?",
          "options": [
            "Server Components cannot catch errors",
            "It receives the error object and reset() function as props, which requires client-side interactivity",
            "File-system conventions only apply to client components",
            "It must re-render without a full page reload"
          ],
          "correct": 1,
          "explanation": "error.tsx receives the error object and a reset() callback. Because it needs to call reset() (a function that triggers a React re-render), it must be a Client Component with the 'use client' directive."
        },
        {
          "id": 3,
          "question": "What is the purpose of route groups in Next.js App Router, e.g. (marketing)?",
          "options": [
            "They create nested URL segments like /marketing/page",
            "They group related routes and layouts without affecting the URL path",
            "They mark routes as private and require authentication",
            "They enable parallel rendering of sibling routes"
          ],
          "correct": 1,
          "explanation": "Parentheses in folder names create route groups that are invisible in the URL. They allow you to apply a different layout to a subset of routes (e.g. (auth) routes share an auth layout) without adding a URL segment."
        }
      ]
    }
  },
  {
    "title": "React Server Components & Server Actions: The End of Client-State Waterfalls",
    "duration": "85 min", "videoUrl": "",
    "description": "Understand RSC vs Client Components and how Server Actions replace API routes for mutations.",
    "notes": {
      "overview": "React Server Components (RSC) run exclusively on the server and ship zero JavaScript to the browser. They can directly access databases, file systems, and environment secrets. Server Actions are async functions marked with 'use server' that can be called from Client Components as if they were local functions — Next.js automatically creates a secure HTTP endpoint under the hood.",
      "keyPoints": [
        "RSCs cannot use useState, useEffect, or browser APIs — they are pure data-fetching render functions",
        "Client Components must be marked with 'use client' at the top of the file — this creates a client boundary",
        "Server Actions eliminate the need for manual API route boilerplate for form submissions and mutations",
        "use() hook in Client Components can unwrap Promises passed from Server Components — enabling streaming",
        "The RSC payload is a serialisable JSON-like format, not HTML — it allows client-side navigation without full page reloads"
      ],
      "codeExample": "// app/actions.ts — Server Action\n'use server';\nexport async function createCourse(formData: FormData) {\n  const title = formData.get('title');\n  await db.courses.create({ title }); // direct DB access\n  revalidatePath('/courses');\n}\n\n// Client Component calling the Server Action\n'use client';\nimport { createCourse } from './actions';\nexport function CourseForm() {\n  return <form action={createCourse}><input name=\"title\" /><button>Create</button></form>;\n}",
      "deepDive": "Passing a Server Component as a prop (children) to a Client Component is valid and important — the Server Component still renders on the server, and only its output (RSC payload) crosses the boundary. This pattern lets you keep data-fetching in Server Components while using interactive Client wrappers like modals or tabs.",
      "summary": "RSC and Server Actions shift the architecture from REST API + client fetch() to co-located server logic that feels like a single unified codebase."
    },
    "exercise": {
      "title": "Quiz: React Server Components & Server Actions",
      "timeLimit": 17,
      "questions": [
        {
          "id": 1,
          "question": "Which hook is NOT allowed in a React Server Component?",
          "options": ["use()", "cache()", "useState()", "All hooks work in RSC"],
          "correct": 2,
          "explanation": "useState() is a client-only hook that requires the browser's JS runtime. RSCs run only on the server and cannot use useState, useEffect, useContext, or any other hook that manages client-side state."
        },
        {
          "id": 2,
          "question": "What directive marks a file as containing a Server Action?",
          "options": ["'use server'", "'server only'", "'use action'", "@ServerAction"],
          "correct": 0,
          "explanation": "'use server' at the top of a file or function marks it as a Server Action. Next.js automatically creates a secure HTTP POST endpoint for each exported async function."
        },
        {
          "id": 3,
          "question": "Can you pass a Server Component as the children prop to a Client Component?",
          "options": [
            "No — Client Components cannot receive Server Component children",
            "Yes — the Server Component still renders on the server; only its output crosses the boundary",
            "Yes — but only if the Server Component has no async data fetching",
            "No — it would cause a hydration mismatch"
          ],
          "correct": 1,
          "explanation": "Passing Server Components as children (or any slot prop) to Client Components is the recommended pattern. The Server Component renders on the server; the RSC payload is passed through the Client Component's slot without converting it to a Client Component."
        }
      ]
    }
  },
  {
    "title": "State Management at Scale: Zustand, Jotai, Redux Toolkit & When to Use Each",
    "duration": "80 min", "videoUrl": "",
    "description": "Practical comparison of modern state libraries.",
    "notes": {
      "overview": "Before reaching for a global state library, ask: can React's built-in useState and Context handle this? Server state (API responses) belongs in React Query or SWR, not a global store. Client state that is truly shared across distant components is the only legitimate use case for Zustand, Jotai, or Redux Toolkit.",
      "keyPoints": [
        "Zustand is a single store with selectors — components only re-render when their selected slice changes",
        "Jotai is atom-based: small, composable pieces of state derived from other atoms, similar to Recoil but lighter",
        "Redux Toolkit (RTK) eliminates boilerplate with createSlice and RTK Query, making Redux practical for large teams",
        "React Query / TanStack Query manages server state (caching, refetching, stale-while-revalidate) — it is not a replacement for client state",
        "Context + useReducer is sufficient for small-to-medium apps; avoid adding a library until you hit real pain"
      ],
      "codeExample": "// Zustand store\nimport { create } from 'zustand';\nconst useCartStore = create((set, get) => ({\n  items: [],\n  total: 0,\n  addItem: (item) => set(state => ({\n    items: [...state.items, item],\n    total: state.total + item.price\n  })),\n  clearCart: () => set({ items: [], total: 0 })\n}));\n\n// Component — only re-renders when 'total' changes\nconst total = useCartStore(s => s.total);",
      "deepDive": "Redux DevTools time-travel debugging — stepping backwards through dispatched actions — is uniquely powerful for debugging complex user flows. If your application has complicated multi-step workflows where the exact sequence of state changes matters (checkout flows, wizards, multi-player games), Redux Toolkit's predictable action log is worth the overhead of the pattern.",
      "summary": "Choose the simplest tool that solves your actual problem — most apps need React Query for server state and Zustand for the tiny slice of genuine client-only global state."
    },
    "exercise": {
      "title": "Quiz: State Management Patterns",
      "timeLimit": 16,
      "questions": [
        {
          "id": 1,
          "question": "Which library is purpose-built for server state management (caching API responses, background refetching)?",
          "options": ["Zustand", "Redux Toolkit", "TanStack Query (React Query)", "Jotai"],
          "correct": 2,
          "explanation": "TanStack Query (React Query) manages the full lifecycle of server state: fetching, caching, deduplication, background updates, stale-while-revalidate, and optimistic updates. Zustand/Redux are for client state."
        },
        {
          "id": 2,
          "question": "In Zustand, how do you prevent a component from re-rendering when an unrelated part of the store changes?",
          "options": [
            "Wrap the component in React.memo",
            "Use a selector function: useStore(state => state.specificSlice)",
            "Split the store into multiple files",
            "Call useStore() inside useEffect"
          ],
          "correct": 1,
          "explanation": "Zustand uses selector functions to subscribe components to only a slice of store state. The component re-renders only when the selector's return value changes, not on every store mutation."
        },
        {
          "id": 3,
          "question": "What does RTK Query's createApi do?",
          "options": [
            "Creates a REST API server",
            "Generates typed hooks for data fetching, caching, and cache invalidation based on endpoint definitions",
            "Creates a Redux middleware for logging",
            "Wraps fetch() with automatic retry logic"
          ],
          "correct": 1,
          "explanation": "createApi from Redux Toolkit Query generates useGetXQuery and useMutateXMutation hooks automatically from your endpoint definitions. It handles caching, loading/error states, and tag-based cache invalidation."
        }
      ]
    }
  },
  {
    "title": "GraphQL API Design with Apollo Server 4 & Apollo Client 3",
    "duration": "90 min", "videoUrl": "",
    "description": "Design schema-first APIs and consume them from React with a normalised cache.",
    "notes": {
      "overview": "GraphQL is a query language for APIs where the client specifies exactly what data it needs. Unlike REST, a single GraphQL endpoint handles all requests via queries (reads) and mutations (writes). Apollo Server handles schema definition and resolver execution; Apollo Client manages the normalised in-memory cache on the client side.",
      "keyPoints": [
        "Schema-first development: define the SDL (Schema Definition Language) before writing any resolver code",
        "Resolvers form a tree that mirrors the schema — each field can have its own resolver that runs lazily",
        "The N+1 problem occurs when resolving a list field triggers one database query per item — solve with DataLoader batching",
        "Apollo Client's InMemoryCache normalises by __typename + id — meaning a mutation response automatically updates every list that contains that entity",
        "Fragments let you co-locate data requirements with the component that uses them — the foundation of Relay-style component data"
      ],
      "codeExample": "// Schema (SDL)\ntype Course { id: ID! title: String! instructor: User! }\ntype Query { courses(category: String): [Course!]! }\ntype Mutation { enrollInCourse(courseId: ID!): Enrollment! }\n\n// Resolver with DataLoader\nconst resolvers = {\n  Course: {\n    instructor: ({ instructorId }, _, { loaders }) =>\n      loaders.user.load(instructorId) // batched!\n  }\n};\n\n// Client query\nconst { data, loading } = useQuery(GET_COURSES, { variables: { category } });",
      "deepDive": "Apollo Client's cache stores entities by __typename:id key. If a mutation returns an updated Course object with the same id that's already in a cached query result, the cache update happens automatically — no manual cache manipulation needed. This automatic normalisation is why explicitly returning updated objects from mutations (rather than just 'success') is critical.",
      "summary": "GraphQL's biggest win is eliminating over-fetching and under-fetching — each component describes exactly the data shape it needs and nothing more."
    },
    "exercise": {
      "title": "Quiz: GraphQL & Apollo",
      "timeLimit": 18,
      "questions": [
        {
          "id": 1,
          "question": "What problem does DataLoader solve in GraphQL resolvers?",
          "options": [
            "Slow schema validation",
            "The N+1 query problem — batching multiple individual lookups into one database query",
            "Large response payloads",
            "Authentication in resolvers"
          ],
          "correct": 1,
          "explanation": "When resolving a list of 100 courses, each course.instructor field resolver would fire a separate DB query (101 queries total). DataLoader batches all instructor lookups from a single tick into one query."
        },
        {
          "id": 2,
          "question": "In Apollo Client's InMemoryCache, how are objects identified for normalisation?",
          "options": [
            "By their position in the query response",
            "By __typename + id, forming a cache key like Course:abc123",
            "By the query variable used to fetch them",
            "By a manually assigned cache key in the query"
          ],
          "correct": 1,
          "explanation": "Apollo Client normalises by default using __typename + id as the cache key (e.g. Course:abc123). This means any query or mutation returning that entity automatically updates all references in the cache."
        },
        {
          "id": 3,
          "question": "What is the difference between a Query and a Mutation in GraphQL?",
          "options": [
            "Queries use GET; mutations use POST",
            "Queries are read-only and can run in parallel; mutations are write operations that run serially",
            "Queries are client-side; mutations are server-side",
            "There is no functional difference — the names are only conventions"
          ],
          "correct": 1,
          "explanation": "By GraphQL spec, Queries are intended to be side-effect-free reads and can execute fields in parallel. Mutations are write operations; multiple mutations in a single request execute sequentially in order."
        }
      ]
    }
  },
  {
    "title": "Real-Time Features: WebSockets, Server-Sent Events & Optimistic UI Updates",
    "duration": "75 min", "videoUrl": "",
    "description": "Build a real-time collaborative feature comparing WebSockets vs SSE.",
    "notes": {
      "overview": "Real-time communication on the web has three main options: polling (simplest, most wasteful), Server-Sent Events (one-way server push, native browser support, auto-reconnect), and WebSockets (full-duplex, requires keepalive management). For most notification/feed use cases, SSE is the correct choice; WebSockets are justified for chat, collaborative editing, and multiplayer games.",
      "keyPoints": [
        "WebSockets provide full-duplex communication over a single persistent TCP connection — both sides can send at any time",
        "SSE (EventSource API) is HTTP-based, one-directional (server → client), and automatically reconnects on disconnect",
        "Optimistic UI updates apply the expected result immediately in the UI then roll back if the server returns an error",
        "Socket.io adds rooms, namespaces, and automatic fallback (WebSocket → polling) but adds significant bundle size",
        "For collaborative apps, CRDTs (Conflict-free Replicated Data Types) resolve concurrent edits without a central authority"
      ],
      "codeExample": "// SSE — server (Express)\napp.get('/events', (req, res) => {\n  res.set({ 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache' });\n  const send = (data) => res.write(`data: ${JSON.stringify(data)}\\n\\n`);\n  const interval = setInterval(() => send({ time: Date.now() }), 1000);\n  req.on('close', () => clearInterval(interval));\n});\n\n// SSE — client\nconst es = new EventSource('/events');\nes.onmessage = (e) => setMessages(prev => [...prev, JSON.parse(e.data)]);",
      "deepDive": "Optimistic updates in React Query are implemented by storing the previous cache value in onMutate, applying the optimistic data, and calling queryClient.setQueryData. In onError, you restore the previous value. The key insight: you must always handle the rollback — an optimistic UI that fails silently and shows wrong data is worse than a spinner.",
      "summary": "Prefer SSE for unidirectional real-time feeds and reserve WebSockets for true bidirectional communication, always pairing optimistic updates with a robust rollback strategy."
    },
    "exercise": {
      "title": "Quiz: Real-Time Web Communication",
      "timeLimit": 15,
      "questions": [
        {
          "id": 1,
          "question": "What is the key advantage of Server-Sent Events (SSE) over WebSockets for a notification feed?",
          "options": [
            "SSE supports bidirectional communication",
            "SSE is HTTP-based with automatic reconnection, lower complexity, and native browser support",
            "SSE has lower latency than WebSockets",
            "SSE works without a server"
          ],
          "correct": 1,
          "explanation": "SSE runs over standard HTTP, works through proxies and firewalls, reconnects automatically, and requires no special server setup. For one-directional pushes (notifications, live feeds), it is simpler and more appropriate than WebSockets."
        },
        {
          "id": 2,
          "question": "What must you always implement alongside an optimistic UI update?",
          "options": [
            "A loading spinner",
            "A rollback mechanism to restore the previous state if the server request fails",
            "A confirmation modal",
            "An animation to indicate the change"
          ],
          "correct": 1,
          "explanation": "An optimistic update that silently fails and shows incorrect data is a data integrity bug. You must store the previous state and restore it in the error handler to keep the UI consistent with the server truth."
        },
        {
          "id": 3,
          "question": "Which JavaScript API creates a persistent SSE connection from the browser?",
          "options": ["WebSocket", "EventSource", "BroadcastChannel", "fetch() with ReadableStream"],
          "correct": 1,
          "explanation": "EventSource is the built-in browser API for Server-Sent Events. It opens a persistent HTTP connection and fires onmessage events for each data: frame received from the server."
        }
      ]
    }
  },
  {
    "title": "Web Performance: Core Web Vitals, Code Splitting, Bundle Analysis & Image Optimisation",
    "duration": "70 min", "videoUrl": "",
    "description": "Measure and improve LCP, CLS, and FID to hit green on PageSpeed Insights.",
    "notes": {
      "overview": "Google's Core Web Vitals measure user-perceived performance: LCP (Largest Contentful Paint, should be < 2.5 s), CLS (Cumulative Layout Shift, should be < 0.1), and INP (Interaction to Next Paint, should be < 200 ms). These metrics directly affect SEO ranking and bounce rate — a 1-second LCP improvement can increase conversions by 7%.",
      "keyPoints": [
        "Code splitting with dynamic import() prevents loading all JS upfront — React.lazy + Suspense enables component-level splitting",
        "Bundle analysis with webpack-bundle-analyzer or vite-bundle-visualiser reveals duplicate dependencies and heavy imports",
        "LCP is most often caused by an unoptimised hero image — use next/image or the native <img loading='lazy' fetchpriority='high'> combo",
        "CLS is caused by images without explicit width/height, dynamically injected content, and web fonts without font-display: swap",
        "Preloading critical fonts and preconnecting to third-party origins reduces render-blocking time significantly"
      ],
      "codeExample": "// Route-level code splitting with React.lazy\nconst Dashboard = lazy(() => import('./pages/Dashboard'));\nconst Courses = lazy(() => import('./pages/Courses'));\n\n// In router — Suspense wraps lazy routes\n<Suspense fallback={<PageSkeleton />}>\n  <Routes>\n    <Route path='/' element={<Dashboard />} />\n    <Route path='/courses' element={<Courses />} />\n  </Routes>\n</Suspense>\n\n// Preconnect to CDN in <head>\n<link rel='preconnect' href='https://fonts.googleapis.com' />",
      "deepDive": "Tree-shaking removes unused exports from production bundles, but it only works with ES module syntax (import/export). If you import { debounce } from 'lodash' instead of 'lodash-es', you pull in the entire 531 KB lodash library. Always check whether a library ships an ESM build, or use the per-method import pattern (lodash.debounce) for CJS libraries.",
      "summary": "Performance is a feature — audit with Lighthouse, visualise your bundle, and fix the three most common culprits: unoptimised images, un-split routes, and render-blocking resources."
    },
    "exercise": {
      "title": "Quiz: Core Web Vitals & Performance",
      "timeLimit": 14,
      "questions": [
        {
          "id": 1,
          "question": "Which Core Web Vital measures how long until the largest image or text block in the viewport is rendered?",
          "options": ["CLS", "INP", "LCP", "FCP"],
          "correct": 2,
          "explanation": "LCP (Largest Contentful Paint) measures when the largest content element in the viewport becomes visible. Google's target is under 2.5 seconds. It is most commonly degraded by unoptimised hero images."
        },
        {
          "id": 2,
          "question": "What causes Cumulative Layout Shift (CLS)?",
          "options": [
            "Slow JavaScript execution",
            "Images without explicit dimensions, injected banners, and fonts without font-display: swap",
            "Large bundle sizes",
            "Too many API calls"
          ],
          "correct": 1,
          "explanation": "CLS measures unexpected visual shifts. Images without width/height cause layout shifts when they load. Late-loading ads/banners push content down. Fonts without font-display: swap cause text to shift when the web font loads."
        },
        {
          "id": 3,
          "question": "Why does importing from 'lodash' instead of 'lodash-es' harm bundle size even with tree-shaking?",
          "options": [
            "lodash-es has more functions than lodash",
            "Tree-shaking only works with ES module (import/export) syntax — lodash ships CommonJS, preventing dead-code elimination",
            "Webpack cannot process lodash imports",
            "There is no difference — both are tree-shaken equally"
          ],
          "correct": 1,
          "explanation": "Tree-shaking relies on static ES module analysis. lodash ships as CommonJS (require/module.exports) which bundlers cannot statically analyse, so the entire library is included. lodash-es ships ESM and is fully tree-shakeable."
        }
      ]
    }
  },
  {
    "title": "Testing Pyramid: Unit Tests with Vitest, Component Tests with RTL & E2E with Playwright",
    "duration": "85 min", "videoUrl": "",
    "description": "Build a full test suite and learn what to test at each layer.",
    "notes": {
      "overview": "The testing pyramid prescribes many fast unit tests at the base, fewer integration tests in the middle, and a small number of slow E2E tests at the top. In a React app this maps to: Vitest for pure functions/hooks, React Testing Library (RTL) for component behaviour, and Playwright for critical user journeys. The guiding principle from Kent C. Dodds: 'Test your software the way your users use it.'",
      "keyPoints": [
        "Vitest is Vite-native and fully compatible with Jest APIs — no configuration for TypeScript or ESM needed",
        "RTL queries by accessible role/label (getByRole, getByLabelText) — not by class name or test-id — making tests resilient to refactors",
        "userEvent from @testing-library/user-event simulates real browser interactions (typing, clicking) more accurately than fireEvent",
        "Playwright auto-waits for elements to be visible and actionable, eliminating most flaky sleep() calls in E2E tests",
        "Test coverage percentage is a vanity metric — mutation testing (Stryker) measures whether your tests actually catch bugs"
      ],
      "codeExample": "// RTL component test\ntest('shows error when email is invalid', async () => {\n  render(<LoginForm />);\n  await userEvent.type(screen.getByLabelText(/email/i), 'notanemail');\n  await userEvent.click(screen.getByRole('button', { name: /sign in/i }));\n  expect(screen.getByRole('alert')).toHaveTextContent(/valid email/i);\n});\n\n// Playwright E2E\ntest('user can enroll in a course', async ({ page }) => {\n  await page.goto('/courses/abc123');\n  await page.getByRole('button', { name: 'Enroll Now' }).click();\n  await expect(page.getByText('Successfully enrolled')).toBeVisible();\n});",
      "deepDive": "Avoid testing implementation details: if a test breaks because you renamed a CSS class or refactored a component's internals without changing visible behaviour, the test is measuring the wrong thing. Tests should only break when user-visible behaviour changes. This is why RTL encourages querying by role/label (what the user sees) rather than class name (what the developer wrote).",
      "summary": "A good test suite is a safety net that lets you refactor confidently — write tests that verify behaviour, not implementation, and automate the tedious parts with E2E tests."
    },
    "exercise": {
      "title": "Quiz: Testing Strategy & Tools",
      "timeLimit": 17,
      "questions": [
        {
          "id": 1,
          "question": "Which React Testing Library query is most resilient to component refactors?",
          "options": ["getByTestId('submit-btn')", "getByClassName('btn-primary')", "getByRole('button', { name: /submit/i })", "getByIndex(0)"],
          "correct": 2,
          "explanation": "getByRole queries the accessible role (button) and accessible name (the visible text or aria-label). It tests what users perceive, not implementation details. getByTestId and class queries break on internal refactors."
        },
        {
          "id": 2,
          "question": "What does mutation testing measure that code coverage cannot?",
          "options": [
            "How many lines of code are executed during tests",
            "Whether tests actually detect bugs — by introducing small code mutations and checking if tests fail",
            "How fast the test suite runs",
            "Whether the application works in production"
          ],
          "correct": 1,
          "explanation": "Coverage tells you which lines ran. Mutation testing introduces intentional bugs (mutations) and checks if your tests catch them. A line can be covered but still allow a bug if the assertion is too weak."
        },
        {
          "id": 3,
          "question": "What is Playwright's auto-wait feature?",
          "options": [
            "It automatically pauses tests for 1 second between steps",
            "It retries element locators until they are visible and actionable before performing an action",
            "It waits for all network requests to complete before each assertion",
            "It generates test files automatically from browser recordings"
          ],
          "correct": 1,
          "explanation": "Playwright automatically retries the selector and waits for the element to become visible, stable, and enabled before clicking or typing. This eliminates most flaky test failures caused by race conditions and animation delays."
        }
      ]
    }
  },
  {
    "title": "Containerisation: Docker, Multi-Stage Builds & Docker Compose for Local Dev",
    "duration": "80 min", "videoUrl": "",
    "description": "Containerise a Next.js + Node.js + PostgreSQL stack.",
    "notes": {
      "overview": "Docker packages an application and all its dependencies into an image that runs identically on any machine. A Dockerfile describes how to build the image layer by layer; Docker Compose orchestrates multiple containers (app + database + cache) as a single development environment. The 'works on my machine' excuse disappears when every environment uses the same image.",
      "keyPoints": [
        "Each Dockerfile instruction creates a new layer — Docker caches layers, so order instructions from least to most frequently changed",
        "Multi-stage builds use multiple FROM instructions: a 'builder' stage installs devDependencies and compiles; a 'runner' stage copies only the production output",
        "COPY package*.json ./ before COPY . ./ so the npm install layer is cached unless package.json changes",
        "Named volumes in Docker Compose persist database data across container restarts — without a volume, data is lost on docker compose down",
        "Health checks ensure dependent services (e.g. the app) wait for the database to be ready before starting"
      ],
      "codeExample": "# Multi-stage Next.js Dockerfile\nFROM node:20-alpine AS builder\nWORKDIR /app\nCOPY package*.json ./\nRUN npm ci\nCOPY . .\nRUN npm run build\n\nFROM node:20-alpine AS runner\nWORKDIR /app\nENV NODE_ENV=production\nCOPY --from=builder /app/.next/standalone ./\nCOPY --from=builder /app/public ./public\nCMD [\"node\", \"server.js\"]",
      "deepDive": "The principle of least privilege applies to Docker too: never run containers as root. Add RUN addgroup -S appgroup && adduser -S appuser -G appgroup in your Dockerfile and switch with USER appuser before CMD. Also avoid storing secrets in environment variables baked into the image — use Docker secrets or a secrets manager injected at runtime.",
      "summary": "Docker makes your development environment reproducible and your production deployment predictable — multi-stage builds keep images lean and secure."
    },
    "exercise": {
      "title": "Quiz: Docker & Containerisation",
      "timeLimit": 16,
      "questions": [
        {
          "id": 1,
          "question": "Why should COPY package*.json ./ appear before COPY . ./ in a Dockerfile?",
          "options": [
            "It is a Docker syntax requirement",
            "So the expensive npm install layer is cached and only re-runs when package.json changes, not on every source file change",
            "It reduces the final image size",
            "It prevents security vulnerabilities"
          ],
          "correct": 1,
          "explanation": "Docker caches layers. If package*.json hasn't changed, the npm install layer is served from cache even when source files change, making subsequent builds much faster."
        },
        {
          "id": 2,
          "question": "What is the purpose of multi-stage builds?",
          "options": [
            "To run tests and production simultaneously",
            "To separate the build environment (with dev tools) from the lean production image (output only)",
            "To support multiple Node.js versions",
            "To enable parallel layer caching"
          ],
          "correct": 1,
          "explanation": "Multi-stage builds let you use a fat 'builder' image with compilers and devDependencies, then COPY only the compiled output to a minimal 'runner' image. Production images can be 10–50× smaller."
        },
        {
          "id": 3,
          "question": "What happens to PostgreSQL data if you run 'docker compose down' without a named volume?",
          "options": [
            "Data is automatically backed up to the host filesystem",
            "Data is lost — container file systems are ephemeral",
            "Data persists in a temporary Docker-managed location",
            "PostgreSQL refuses to stop if there is data"
          ],
          "correct": 1,
          "explanation": "Container file systems are ephemeral — they are destroyed when the container is removed. Named volumes (volumes: postgres_data:/var/lib/postgresql/data) persist data on the host machine across container restarts and removals."
        }
      ]
    }
  },
  {
    "title": "CI/CD with GitHub Actions: Lint, Test, Build, Preview & Production Deployment",
    "duration": "70 min", "videoUrl": "",
    "description": "Automate the full release pipeline from commit to live URL.",
    "notes": {
      "overview": "Continuous Integration (CI) runs automated checks on every push to detect problems early. Continuous Deployment (CD) automatically deploys code that passes all checks to production. GitHub Actions is a CI/CD platform built into GitHub — workflows are YAML files in .github/workflows/ that trigger on push, pull_request, or schedule events.",
      "keyPoints": [
        "A workflow consists of one or more jobs; jobs run in parallel by default and can declare 'needs' to enforce sequencing",
        "Secrets (API keys, deploy tokens) are stored in Settings → Secrets and accessed via ${{ secrets.MY_KEY }} — never hardcoded in YAML",
        "Matrix strategy runs the same job with multiple configurations (e.g. node versions 18, 20, 22) in parallel",
        "Caching node_modules with actions/cache keyed on package-lock.json hash reduces install time from 60s to 5s",
        "Environment protection rules (require a reviewer before deploying to production) add a human gate to automated pipelines"
      ],
      "codeExample": "# .github/workflows/ci.yml\nname: CI\non: [push, pull_request]\njobs:\n  test:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - uses: actions/setup-node@v4\n        with: { node-version: 20, cache: 'npm' }\n      - run: npm ci\n      - run: npm run lint\n      - run: npm test -- --coverage\n  deploy:\n    needs: test\n    if: github.ref == 'refs/heads/main'\n    runs-on: ubuntu-latest\n    steps:\n      - run: curl -X POST ${{ secrets.RENDER_DEPLOY_HOOK }}",
      "deepDive": "GitHub Actions OIDC (OpenID Connect) eliminates the need for long-lived static credentials to cloud providers. Instead of storing an AWS_SECRET_KEY in GitHub Secrets, you configure AWS to trust GitHub's OIDC provider and issue temporary credentials scoped to the specific repo and branch. If credentials are leaked they expire automatically.",
      "summary": "A CI/CD pipeline that runs in under 5 minutes transforms your team's confidence — every merge to main is automatically tested and deployed with no manual steps."
    },
    "exercise": {
      "title": "Quiz: GitHub Actions & CI/CD",
      "timeLimit": 14,
      "questions": [
        {
          "id": 1,
          "question": "How do you make a GitHub Actions job wait for another job to succeed before starting?",
          "options": [
            "Use 'after: job-name'",
            "Use 'needs: job-name' in the dependent job",
            "Use 'depends-on: job-name'",
            "Order jobs alphabetically"
          ],
          "correct": 1,
          "explanation": "The 'needs' keyword declares job dependencies. A job with 'needs: test' will only start after the 'test' job completes successfully. Jobs without 'needs' run in parallel."
        },
        {
          "id": 2,
          "question": "How should API keys and tokens be stored in a GitHub Actions workflow?",
          "options": [
            "Hardcoded in the YAML file",
            "In a .env file committed to the repository",
            "In GitHub repository or environment Secrets, accessed via ${{ secrets.KEY_NAME }}",
            "In a JSON config file in .github/"
          ],
          "correct": 2,
          "explanation": "Secrets are stored encrypted in GitHub Settings → Secrets and referenced with ${{ secrets.KEY_NAME }}. They are masked in logs and never exposed to forked pull requests. Never commit credentials to version control."
        },
        {
          "id": 3,
          "question": "What does the GitHub Actions cache action key: ${{ hashFiles('package-lock.json') }} achieve?",
          "options": [
            "Encrypts the cached files for security",
            "Invalidates the cache automatically whenever package-lock.json changes, ensuring fresh installs when dependencies update",
            "Compresses the cache to save storage",
            "Shares the cache between all branches"
          ],
          "correct": 1,
          "explanation": "The cache key includes a hash of package-lock.json. When dependencies change, the hash changes, the old cache misses, and npm ci runs a fresh install. When no dependencies changed, the cached node_modules is restored in seconds."
        }
      ]
    }
  },
  {
    "title": "Capstone Project: Ship a Production Full-Stack App from Zero to Live URL",
    "duration": "120 min", "videoUrl": "",
    "description": "Combine every skill from the course to build and deploy a real SaaS feature.",
    "notes": {
      "overview": "A capstone project synthesises all course skills into a single cohesive deliverable. You will build a 'Course Review' feature end-to-end: database schema, API endpoint, server action, React component with optimistic update, Playwright E2E test, and automated deployment via GitHub Actions to Render (API) and Netlify (frontend).",
      "keyPoints": [
        "Schema-first design: define the data model before writing any code — prevents costly refactors later",
        "Start with the API contract (OpenAPI spec or GraphQL SDL) so frontend and backend can develop in parallel",
        "Feature flags let you deploy code to production before it is user-visible, enabling gradual rollouts",
        "Structured logging (JSON logs with request ID, user ID, duration) makes debugging in production feasible",
        "Monitoring and alerting (uptime checks, error rate thresholds) catch regressions before users report them"
      ],
      "codeExample": "// Full deployment pipeline summary\n// 1. git push → GitHub Actions runs tests\n// 2. If tests pass on main → Render auto-deploys backend\n// 3. Netlify builds & deploys frontend preview per PR\n// 4. On PR merge → Netlify promotes preview to production\n\n// Database migration before deploy (zero-downtime)\n// Old schema → add nullable column → deploy → backfill → add NOT NULL constraint\n// Never add a NOT NULL column without a default in a single migration on a live DB",
      "deepDive": "Zero-downtime database migrations require thinking in three phases: (1) expand — add new columns as nullable or with defaults so the old code still works; (2) deploy new code that reads/writes both old and new; (3) contract — remove old columns once all instances run new code. Skipping this on a live table with millions of rows causes full table locks and downtime.",
      "summary": "Shipping is the skill — combining TypeScript, React, Next.js, Docker, testing, and CI/CD into a single end-to-end workflow is what distinguishes senior engineers."
    },
    "exercise": {
      "title": "Quiz: Production Engineering Practices",
      "timeLimit": 24,
      "questions": [
        {
          "id": 1,
          "question": "What is a zero-downtime database migration strategy?",
          "options": [
            "Drop and recreate the table during a maintenance window",
            "Expand (add nullable columns), deploy code for both schemas, then contract (remove old columns) across multiple deploys",
            "Use transactions to apply all changes atomically",
            "Add NOT NULL columns with a DEFAULT clause in a single migration"
          ],
          "correct": 1,
          "explanation": "Adding a NOT NULL column in one step locks the entire table while backfilling existing rows. The expand-contract pattern (also called blue-green migrations) avoids this by making the schema forward-compatible before deploying new code."
        },
        {
          "id": 2,
          "question": "What is the purpose of a feature flag in a CI/CD pipeline?",
          "options": [
            "To stop the deployment if tests fail",
            "To deploy code to production before it is user-visible, enabling dark launches and gradual rollouts",
            "To label different software versions for rollback",
            "To restrict which branches can trigger deployments"
          ],
          "correct": 1,
          "explanation": "Feature flags decouple deployment from release. Code can be in production for days before being enabled for users. This allows testing in the production environment, gradual percentage rollouts, and instant kill-switch rollback without a code deploy."
        },
        {
          "id": 3,
          "question": "Why should structured (JSON) logging be preferred over plain text logs in production?",
          "options": [
            "JSON logs are compressed and use less disk space",
            "They are machine-parseable — allowing log aggregation tools to filter, search, and alert on specific fields like user_id or error_code",
            "They are easier for humans to read",
            "They are required by cloud providers"
          ],
          "correct": 1,
          "explanation": "Structured logs like { level: 'error', requestId: 'abc', userId: '123', message: '...' } can be ingested by tools like Datadog, Grafana Loki, or CloudWatch and queried with field filters. Plain text logs require fragile regex parsing."
        }
      ]
    }
  }
]
$awd$::jsonb
WHERE title = 'Advanced Web Development';


-- ============================================================
--  2. DATA SCIENCE & MACHINE LEARNING  (first 8 lessons)
-- ============================================================
UPDATE courses SET lessons = $ds$
[
  {
    "title": "Python Scientific Stack: NumPy Arrays, Pandas DataFrames & SciPy Stats",
    "duration": "80 min", "videoUrl": "",
    "description": "Master vectorised operations used in every data science project.",
    "notes": {
      "overview": "NumPy provides the n-dimensional array (ndarray) as a fixed-type, contiguous-memory data structure that is 50–100× faster than Python lists for numerical operations. Pandas builds on NumPy with the DataFrame — a 2-D labelled structure with powerful alignment, grouping, and reshaping. SciPy adds statistical distributions, hypothesis tests, and optimisation algorithms.",
      "keyPoints": [
        "Vectorised operations (np.sum, array * 2) avoid Python loops and run in optimised C — always prefer them",
        "Broadcasting allows NumPy to apply operations between arrays of different shapes following strict dimension-matching rules",
        "Pandas .loc[] selects by label, .iloc[] by integer position — confusing them is a common source of bugs",
        "groupby().agg() chains grouping and aggregation in one step — the pandas equivalent of SQL GROUP BY",
        "Always use .copy() when subsetting a DataFrame to prevent SettingWithCopyWarning and unintended mutations"
      ],
      "codeExample": "import numpy as np, pandas as pd\n\n# Vectorised NumPy — no loop needed\nscores = np.array([72, 85, 91, 63, 88])\nnormalised = (scores - scores.mean()) / scores.std()\n\n# Pandas groupby aggregation\ndf.groupby('category').agg(\n  avg_rating=('rating', 'mean'),\n  total_students=('students', 'sum')\n).reset_index()",
      "deepDive": "Pandas operations on large DataFrames can be slow because Python's GIL limits true parallelism. For DataFrames > 1 GB, consider using Polars (Rust-based, multi-threaded) or Dask (lazy parallel evaluation) instead of vanilla Pandas. Profile with df.memory_usage(deep=True) before optimising.",
      "summary": "NumPy and Pandas are the foundation of the entire Python data science ecosystem — every other library either builds on them or accepts their data structures."
    },
    "exercise": {
      "title": "Quiz: NumPy & Pandas Fundamentals",
      "timeLimit": 16,
      "questions": [
        {
          "id": 1,
          "question": "What does df.loc[2, 'name'] select in a Pandas DataFrame?",
          "options": [
            "The third row (integer position 2), 'name' column",
            "The row with label/index 2, 'name' column",
            "All rows where name equals 2",
            "The cell at column index 2, row named 'name'"
          ],
          "correct": 1,
          "explanation": ".loc[] uses label-based indexing. df.loc[2, 'name'] selects the row whose index label is 2 and the column named 'name'. If the index is the default RangeIndex, label 2 happens to be position 2, but this is not guaranteed for custom indexes."
        },
        {
          "id": 2,
          "question": "Why are NumPy vectorised operations faster than Python loops?",
          "options": [
            "NumPy uses multiple CPU cores automatically",
            "NumPy operations are implemented in C with fixed-type contiguous arrays, eliminating Python interpreter overhead per element",
            "NumPy compiles Python code to machine code at runtime",
            "NumPy uses GPU acceleration by default"
          ],
          "correct": 1,
          "explanation": "NumPy stores elements as fixed-type values in contiguous memory and implements operations in compiled C. Python loops have per-iteration overhead (object boxing, reference counting, dynamic dispatch) that C loops do not."
        },
        {
          "id": 3,
          "question": "What is the purpose of calling .copy() when creating a DataFrame subset?",
          "options": [
            "To improve performance",
            "To prevent SettingWithCopyWarning and ensure changes to the subset do not affect the original DataFrame",
            "To convert the subset to a NumPy array",
            "To create a SQL-queryable copy"
          ],
          "correct": 1,
          "explanation": "Without .copy(), a subset may be a view of the original DataFrame. Modifying the subset can raise SettingWithCopyWarning and may or may not modify the original — the behavior is ambiguous. .copy() creates an independent DataFrame."
        }
      ]
    }
  },
  {
    "title": "Exploratory Data Analysis: Distribution Analysis, Correlation & Visualisation",
    "duration": "75 min", "videoUrl": "",
    "description": "Develop the EDA muscle memory that separates good data scientists.",
    "notes": {
      "overview": "Exploratory Data Analysis (EDA) is the process of summarising, visualising, and understanding a dataset before modelling. It reveals distributions, outliers, missing values, correlations, and data quality issues that would otherwise silently corrupt model training. A thorough EDA often surfaces insights more valuable than the eventual model.",
      "keyPoints": [
        "df.describe() gives count, mean, std, min, quartiles, max — the starting point for every new dataset",
        "Histograms reveal distribution shape (normal, skewed, bimodal); box plots reveal quartiles and outliers",
        "The correlation matrix (df.corr()) shows pairwise linear relationships — but correlation ≠ causation",
        "Missing value patterns matter: MCAR (random), MAR (depends on other columns), MNAR (depends on the missing value itself) require different imputation strategies",
        "Outlier detection: IQR method (values outside 1.5×IQR), Z-score (|z| > 3), or domain knowledge"
      ],
      "codeExample": "import seaborn as sns, matplotlib.pyplot as plt\n\n# Distribution + outliers\nfig, axes = plt.subplots(1, 2, figsize=(12, 4))\ndf['score'].hist(bins=30, ax=axes[0])\ndf.boxplot(column='score', by='category', ax=axes[1])\n\n# Correlation heatmap\nsns.heatmap(df.select_dtypes('number').corr(),\n            annot=True, cmap='coolwarm', center=0)",
      "deepDive": "Anscombe's Quartet is four datasets with nearly identical summary statistics (same mean, variance, correlation) but completely different distributions — proof that visualisation is not optional. Always plot your data. The same warning applies to the Datasaurus Dozen: twelve wildly different scatter plots with identical descriptive statistics.",
      "summary": "EDA is not a box to tick before modelling — it is where domain knowledge meets data, and where most real insights are discovered."
    },
    "exercise": {
      "title": "Quiz: Exploratory Data Analysis",
      "timeLimit": 15,
      "questions": [
        {
          "id": 1,
          "question": "What does a right-skewed (positively skewed) distribution look like?",
          "options": [
            "A symmetric bell curve centred at the mean",
            "A long tail extending to the right with most values concentrated on the left",
            "A long tail extending to the left with most values concentrated on the right",
            "A uniform distribution with no visible skew"
          ],
          "correct": 1,
          "explanation": "A right-skewed distribution has a long right tail. Income distributions are classically right-skewed: most people earn moderate incomes but a few earn very high amounts, pulling the mean above the median."
        },
        {
          "id": 2,
          "question": "What does a Pearson correlation of -0.85 between two variables mean?",
          "options": [
            "One variable causes a decrease in the other",
            "There is a strong negative linear relationship — as one increases, the other tends to decrease",
            "The variables are independent",
            "85% of variance in one variable is explained by the other"
          ],
          "correct": 1,
          "explanation": "Pearson correlation measures linear association: -1 is perfect negative linear correlation, 0 is no linear relationship, +1 is perfect positive. -0.85 is a strong negative linear relationship. Importantly, it says nothing about causation."
        },
        {
          "id": 3,
          "question": "Which missing data mechanism is hardest to handle and most likely to bias model results?",
          "options": [
            "MCAR — Missing Completely At Random",
            "MAR — Missing At Random (depends on observed variables)",
            "MNAR — Missing Not At Random (the missing value itself determines missingness)",
            "All missing data mechanisms introduce equal bias"
          ],
          "correct": 2,
          "explanation": "MNAR (e.g. patients with high blood pressure are less likely to report it) means the missing data pattern is related to the unobserved value itself. Standard imputation assumes MCAR or MAR — MNAR violates this and can severely bias estimates."
        }
      ]
    }
  },
  {
    "title": "Statistical Inference: Confidence Intervals & Hypothesis Testing",
    "duration": "85 min", "videoUrl": "",
    "description": "Understand p-values, Type I/II errors, and when each test is appropriate.",
    "notes": {
      "overview": "Statistical inference draws conclusions about a population from a sample. A confidence interval quantifies uncertainty around an estimate; a hypothesis test evaluates evidence against a null hypothesis. Misinterpreting p-values is one of the most common errors in data science — a p-value is NOT the probability that the null hypothesis is true.",
      "keyPoints": [
        "A 95% CI means: if we repeated the sampling 100 times, 95 of the resulting intervals would contain the true parameter",
        "p-value is the probability of observing results as extreme as the data IF the null hypothesis were true — not the probability the null is false",
        "Type I error (α): rejecting a true null hypothesis (false positive). Type II error (β): failing to reject a false null (false negative)",
        "Statistical power = 1 - β: the probability of detecting a real effect. Depends on sample size, effect size, and α",
        "Use t-test for comparing two means, ANOVA for multiple groups, chi-square for categorical associations"
      ],
      "codeExample": "from scipy import stats\nimport numpy as np\n\n# Independent samples t-test\ngroup_a = np.array([82, 75, 90, 88, 76])\ngroup_b = np.array([70, 68, 74, 71, 73])\nt_stat, p_value = stats.ttest_ind(group_a, group_b)\n\n# 95% Confidence interval for a mean\nn, mean, std = len(group_a), np.mean(group_a), np.std(group_a, ddof=1)\nci = stats.t.interval(0.95, df=n-1, loc=mean, scale=std/np.sqrt(n))\nprint(f't={t_stat:.2f}, p={p_value:.4f}, 95% CI={ci}')",
      "deepDive": "P-hacking (running multiple tests until you find p < 0.05) inflates the false positive rate. If you run 20 tests at α=0.05, you expect one false positive by chance. Apply the Bonferroni correction (divide α by the number of tests) or use the Benjamini-Hochberg procedure to control the false discovery rate across multiple comparisons.",
      "summary": "Statistical inference is the bridge between sample observations and population conclusions — understanding its assumptions and limitations prevents confidently wrong decisions."
    },
    "exercise": {
      "title": "Quiz: Statistical Inference",
      "timeLimit": 17,
      "questions": [
        {
          "id": 1,
          "question": "A study reports p = 0.03. What does this mean?",
          "options": [
            "There is a 3% probability that the null hypothesis is true",
            "There is a 97% probability the alternative hypothesis is true",
            "If the null hypothesis were true, the probability of observing data this extreme (or more) is 3%",
            "The effect is large and practically significant"
          ],
          "correct": 2,
          "explanation": "A p-value is NOT the probability the null is true or false. It is the probability of observing results as extreme as the data GIVEN that the null hypothesis is true. p = 0.03 means this outcome is unlikely under the null — not that the null has 3% chance of being true."
        },
        {
          "id": 2,
          "question": "What is a Type II error?",
          "options": [
            "Rejecting a true null hypothesis (false positive)",
            "Failing to reject a false null hypothesis (false negative / missed effect)",
            "Using the wrong statistical test",
            "Having an insufficient sample size"
          ],
          "correct": 1,
          "explanation": "Type II error (β) is failing to detect a real effect — a false negative. For example, concluding a drug has no effect when it actually does. Statistical power (1-β) measures the probability of correctly detecting a real effect."
        },
        {
          "id": 3,
          "question": "When should you use a chi-square test instead of a t-test?",
          "options": [
            "When comparing means of two continuous variables",
            "When testing association between two categorical variables",
            "When the sample size is very large",
            "When data is normally distributed"
          ],
          "correct": 1,
          "explanation": "The chi-square test of independence assesses whether two categorical variables are associated (e.g. gender vs. product preference). The t-test compares means of continuous variables between groups."
        }
      ]
    }
  },
  {
    "title": "Feature Engineering: Encoding, Scaling, Imputation & Selection",
    "duration": "80 min", "videoUrl": "",
    "description": "Transform raw data into model-ready features.",
    "notes": {
      "overview": "Feature engineering is the process of transforming raw data into inputs that machine learning models can learn from effectively. Most algorithms require numerical input, have assumptions about feature scale, and cannot handle missing values. Thoughtful feature engineering often has more impact on model performance than algorithm choice.",
      "keyPoints": [
        "One-hot encoding converts categorical variables to binary columns — use pd.get_dummies or sklearn's OneHotEncoder, always drop one category to avoid the dummy variable trap",
        "StandardScaler (zero mean, unit variance) is required by distance-based algorithms (KNN, SVM, PCA); tree-based models are scale-invariant",
        "Never fit a scaler on the full dataset — fit only on training data, then transform train and test separately to prevent data leakage",
        "Median imputation is robust to outliers; for high-cardinality categoricals, group-mean imputation often outperforms simple strategies",
        "Feature selection reduces dimensionality: correlation-based filtering, mutual information, or L1 regularisation (Lasso) all serve different use cases"
      ],
      "codeExample": "from sklearn.pipeline import Pipeline\nfrom sklearn.preprocessing import StandardScaler, OneHotEncoder\nfrom sklearn.impute import SimpleImputer\nfrom sklearn.compose import ColumnTransformer\n\nnumeric_pipe = Pipeline([('impute', SimpleImputer(strategy='median')), ('scale', StandardScaler())])\ncat_pipe = Pipeline([('impute', SimpleImputer(strategy='most_frequent')), ('encode', OneHotEncoder(drop='first', handle_unknown='ignore'))])\n\npreprocessor = ColumnTransformer([\n  ('num', numeric_pipe, numeric_cols),\n  ('cat', cat_pipe, categorical_cols)\n])",
      "deepDive": "Data leakage — when information from the test set or future data contaminates training — is the most dangerous and common modelling mistake. It produces unrealistically high validation scores that collapse in production. Always use sklearn Pipelines with cross-validation to guarantee the preprocessor is fit only on the training fold at each split.",
      "summary": "A sklearn Pipeline that encodes, imputes, scales, and models in one reproducible object is the single most important engineering practice for production machine learning."
    },
    "exercise": {
      "title": "Quiz: Feature Engineering & Pipelines",
      "timeLimit": 16,
      "questions": [
        {
          "id": 1,
          "question": "Why should a StandardScaler be fitted only on training data?",
          "options": [
            "It is computationally expensive to fit on large datasets",
            "Fitting on the full dataset leaks test set statistics (mean, std) into training, producing optimistically biased evaluation metrics",
            "The scaler produces different results on train vs test data",
            "StandardScaler only supports training data as input"
          ],
          "correct": 1,
          "explanation": "If you compute the mean and std on train + test combined, the test data's statistics influence the transformation applied to training data. This is data leakage — the model indirectly 'sees' the test set during training, making validation metrics unreliable."
        },
        {
          "id": 2,
          "question": "Which encoding method should you use for a categorical feature with 200 unique values (high cardinality)?",
          "options": [
            "One-hot encoding — always the safest choice",
            "Label encoding (0, 1, 2...) — works for all cardinalities",
            "Target encoding or embeddings — one-hot creates 200 sparse columns that overwhelm distance-based models",
            "Simply drop high-cardinality features"
          ],
          "correct": 2,
          "explanation": "One-hot encoding a 200-value categorical creates 200 binary columns, making the feature space very wide and sparse. Target encoding (replace category with mean target value) or learned embeddings (for deep learning) handle high cardinality more effectively."
        },
        {
          "id": 3,
          "question": "What is the 'dummy variable trap' in one-hot encoding?",
          "options": [
            "Encoding too many features at once",
            "Including all k binary columns for k categories, creating perfect multicollinearity that breaks linear models",
            "Using integer labels instead of binary columns",
            "Encoding test data differently from training data"
          ],
          "correct": 1,
          "explanation": "For k categories, only k-1 binary columns are needed — the last category is implied when all others are 0. Including all k creates perfect multicollinearity (the columns sum to 1) which makes the design matrix singular and regression coefficients unidentifiable."
        }
      ]
    }
  },
  {
    "title": "Supervised Learning I: Linear & Logistic Regression — Theory, Assumptions & Diagnostics",
    "duration": "85 min", "videoUrl": "",
    "description": "Go beyond fitting — interpret coefficients, check residuals, and tune regularisation.",
    "notes": {
      "overview": "Linear regression models a continuous outcome as a weighted sum of features. Logistic regression models the log-odds of a binary outcome — its output is a probability via the sigmoid function. Both are the most interpretable models in supervised learning and often serve as the baseline every more complex model must beat.",
      "keyPoints": [
        "Linear regression assumes: linearity, independence, homoscedasticity (constant residual variance), normality of residuals, no perfect multicollinearity",
        "Ordinary Least Squares (OLS) minimises the sum of squared residuals — the analytical solution is β = (XᵀX)⁻¹Xᵀy",
        "Ridge regression (L2) shrinks coefficients towards zero — good for multicollinearity. Lasso (L1) drives some coefficients to exactly zero — automatic feature selection",
        "Logistic regression's sigmoid output σ(z) = 1/(1+e⁻ᶻ) converts the linear combination z = Xβ to a probability between 0 and 1",
        "ROC-AUC measures discrimination across all classification thresholds; threshold selection depends on the relative cost of false positives vs false negatives"
      ],
      "codeExample": "from sklearn.linear_model import LogisticRegression, Ridge\nfrom sklearn.metrics import classification_report, roc_auc_score\n\n# Logistic regression with L2 regularisation\nmodel = LogisticRegression(C=0.1, max_iter=1000)  # C = 1/lambda\nmodel.fit(X_train, y_train)\ny_prob = model.predict_proba(X_test)[:, 1]\n\nprint(classification_report(y_test, model.predict(X_test)))\nprint(f'ROC-AUC: {roc_auc_score(y_test, y_prob):.3f}')",
      "deepDive": "The coefficient C in sklearn's LogisticRegression is the inverse of regularisation strength — C=0.01 means strong regularisation, C=100 means almost none. Tune C with cross-validation (LogisticRegressionCV). High multicollinearity (VIF > 5) makes individual coefficients uninterpretable — Ridge regression stabilises them at the cost of pure interpretability.",
      "summary": "Linear and logistic regression are the interpretable bedrock of supervised learning — always run them first to establish a baseline and understand the relationship between features and outcomes."
    },
    "exercise": {
      "title": "Quiz: Linear & Logistic Regression",
      "timeLimit": 17,
      "questions": [
        {
          "id": 1,
          "question": "What is the key difference between Lasso (L1) and Ridge (L2) regularisation?",
          "options": [
            "Lasso works for regression; Ridge works for classification",
            "Lasso can shrink coefficients to exactly zero (feature selection); Ridge shrinks towards zero but rarely eliminates features",
            "Ridge has a larger regularisation penalty than Lasso",
            "Lasso minimises mean absolute error; Ridge minimises mean squared error"
          ],
          "correct": 1,
          "explanation": "L1 (Lasso) regularisation adds |β| to the loss function, which creates sparsity by driving some coefficients to exactly zero — effectively selecting features. L2 (Ridge) adds β² which distributes the penalty across all features, shrinking them towards zero but rarely to exactly zero."
        },
        {
          "id": 2,
          "question": "What does the sigmoid function do in logistic regression?",
          "options": [
            "Normalises the input features",
            "Maps any real-valued number to a probability between 0 and 1",
            "Calculates the gradient during training",
            "Converts the continuous output to a discrete class label"
          ],
          "correct": 1,
          "explanation": "The sigmoid σ(z) = 1/(1+e⁻ᶻ) maps the linear combination Xβ (which can be any real value) to the range (0,1), producing a probability. The class prediction applies a threshold (usually 0.5) to this probability."
        },
        {
          "id": 3,
          "question": "What does an ROC-AUC of 0.5 indicate?",
          "options": [
            "The model has 50% accuracy",
            "The model performs no better than random guessing",
            "The model correctly classifies 50% of positives",
            "The false positive rate equals 50%"
          ],
          "correct": 1,
          "explanation": "AUC = 0.5 means the model's discrimination is equivalent to randomly assigning probabilities — the ROC curve lies on the diagonal. A perfect classifier has AUC = 1.0. AUC < 0.5 suggests the model's predictions are inverted."
        }
      ]
    }
  },
  {
    "title": "Supervised Learning II: Decision Trees, Random Forests, Gradient Boosting & XGBoost",
    "duration": "90 min", "videoUrl": "",
    "description": "Tune tree-based models with Optuna and interpret them with SHAP values.",
    "notes": {
      "overview": "Decision trees partition the feature space by asking binary questions that maximally separate class labels (measured by Gini impurity or information gain). They are interpretable but overfit aggressively. Random Forest averages many decorrelated trees for variance reduction; Gradient Boosting builds trees sequentially, each correcting the errors of the previous — XGBoost is the most engineered implementation of this idea.",
      "keyPoints": [
        "Decision trees overfit with no depth limit — max_depth, min_samples_split, and min_samples_leaf are the primary regularisation hyperparameters",
        "Random Forest reduces variance via bagging (bootstrap aggregation) and feature randomness — each tree sees a random subset of features",
        "Gradient Boosting minimises a differentiable loss function by fitting each new tree to the negative gradient (pseudo-residuals) of the previous ensemble",
        "XGBoost adds L1/L2 regularisation, column subsampling, and a weighted quantile sketch for approximate split finding — enabling training on datasets that do not fit in memory",
        "SHAP (SHapley Additive exPlanations) values decompose each prediction into additive feature contributions — the gold standard for tree model interpretability"
      ],
      "codeExample": "import xgboost as xgb\nimport shap\n\nmodel = xgb.XGBClassifier(\n  n_estimators=500,\n  learning_rate=0.05,\n  max_depth=6,\n  subsample=0.8,\n  colsample_bytree=0.8,\n  eval_metric='auc',\n  early_stopping_rounds=20\n)\nmodel.fit(X_train, y_train, eval_set=[(X_val, y_val)])\n\n# SHAP waterfall plot for a single prediction\nexplainer = shap.TreeExplainer(model)\nshap_values = explainer(X_test)\nshap.plots.waterfall(shap_values[0])",
      "deepDive": "Early stopping (early_stopping_rounds=20) monitors validation loss and halts training when performance stops improving — preventing overfitting and reducing training time. The n_estimators parameter becomes a maximum rather than a fixed target. Combined with a low learning_rate (0.01–0.1), early stopping usually finds a better optimum than grid-searching n_estimators.",
      "summary": "XGBoost + SHAP is the dominant combination for tabular data — XGBoost wins competitions; SHAP makes the predictions explainable to stakeholders and regulators."
    },
    "exercise": {
      "title": "Quiz: Ensemble Methods",
      "timeLimit": 18,
      "questions": [
        {
          "id": 1,
          "question": "How does Random Forest reduce the variance of individual decision trees?",
          "options": [
            "By using deeper trees than standard decision trees",
            "By averaging predictions across many trees trained on bootstrap samples with random feature subsets, reducing correlation between trees",
            "By applying L2 regularisation to each tree's splits",
            "By limiting tree depth more aggressively than a single tree"
          ],
          "correct": 1,
          "explanation": "Random Forest combines bagging (each tree is trained on a bootstrap sample) with feature randomness (each split considers only a subset of features). Averaging uncorrelated predictions reduces variance without increasing bias."
        },
        {
          "id": 2,
          "question": "What does each new tree in Gradient Boosting learn to predict?",
          "options": [
            "The original target variable",
            "The residual errors (negative gradient of the loss) of the current ensemble",
            "A random subset of training samples",
            "The average prediction of all previous trees"
          ],
          "correct": 1,
          "explanation": "Gradient Boosting fits each new tree to the pseudo-residuals — the gradient of the loss function with respect to the current predictions. The new tree corrects the specific errors the ensemble currently makes."
        },
        {
          "id": 3,
          "question": "What do SHAP values represent for a single prediction?",
          "options": [
            "The feature importances across the entire training dataset",
            "The additive contribution of each feature to a specific individual prediction relative to the expected (baseline) prediction",
            "The probability that each feature caused the prediction",
            "The rank order of features by their correlation with the target"
          ],
          "correct": 1,
          "explanation": "SHAP values decompose a prediction into the sum of contributions from each feature. For a specific prediction, each feature's SHAP value shows how much it pushed the output above or below the baseline (average) prediction — enabling local, instance-level explanation."
        }
      ]
    }
  },
  {
    "title": "Unsupervised Learning: K-Means, DBSCAN, Hierarchical Clustering & PCA",
    "duration": "80 min", "videoUrl": "",
    "description": "Segment customers, detect anomalies, and compress high-dimensional data.",
    "notes": {
      "overview": "Unsupervised learning finds patterns in data without labelled outcomes. Clustering groups similar observations; dimensionality reduction compresses features while preserving structure. These techniques are used for customer segmentation, anomaly detection, recommendation systems, and as preprocessing steps for supervised models.",
      "keyPoints": [
        "K-Means minimises within-cluster sum of squared distances — sensitive to initialisation (use k-means++), outliers, and requires specifying k in advance",
        "DBSCAN defines clusters by density: core points have ≥ minPts neighbours within ε — outliers are labelled -1, allowing arbitrary cluster shapes",
        "Hierarchical clustering builds a dendrogram (tree of merges) — cut at the right height to choose k without rerunning; Ward linkage minimises within-cluster variance",
        "PCA finds orthogonal directions of maximum variance — projecting onto the top k principal components retains most information in fewer dimensions",
        "Use silhouette score (range -1 to 1) to evaluate cluster quality without ground-truth labels — values > 0.5 indicate reasonable structure"
      ],
      "codeExample": "from sklearn.cluster import KMeans, DBSCAN\nfrom sklearn.decomposition import PCA\nfrom sklearn.preprocessing import StandardScaler\n\n# Scale first — K-Means and PCA are sensitive to scale\nX_scaled = StandardScaler().fit_transform(X)\n\n# PCA to 2D for visualisation\npca = PCA(n_components=2)\nX_2d = pca.fit_transform(X_scaled)\nprint(f'Variance explained: {pca.explained_variance_ratio_.sum():.1%}')\n\n# K-Means\nkmeans = KMeans(n_clusters=4, init='k-means++', n_init=10, random_state=42)\nlabels = kmeans.fit_predict(X_scaled)",
      "deepDive": "The curse of dimensionality makes distance-based algorithms (K-Means, KNN, DBSCAN) increasingly unreliable as the number of features grows — in high dimensions, all points become approximately equidistant. Always reduce dimensions with PCA or UMAP before clustering, and validate cluster stability by running the algorithm multiple times with different random seeds.",
      "summary": "Unsupervised learning is hypothesis generation, not validation — use domain expertise to interpret whether discovered clusters represent meaningful, actionable segments."
    },
    "exercise": {
      "title": "Quiz: Clustering & Dimensionality Reduction",
      "timeLimit": 16,
      "questions": [
        {
          "id": 1,
          "question": "What is a key limitation of K-Means clustering?",
          "options": [
            "It can only process text data",
            "It requires you to specify the number of clusters k in advance and assumes spherical, similarly-sized clusters",
            "It cannot handle continuous features",
            "It always produces the same clusters regardless of initialisation"
          ],
          "correct": 1,
          "explanation": "K-Means requires k to be specified upfront, assumes clusters are convex and similarly sized, and is sensitive to outliers. DBSCAN does not require specifying k and can find arbitrary-shaped clusters."
        },
        {
          "id": 2,
          "question": "What does the explained_variance_ratio_ attribute of PCA tell you?",
          "options": [
            "The percentage of features retained",
            "The proportion of total variance in the data captured by each principal component",
            "The correlation between original features and principal components",
            "The optimal number of principal components to use"
          ],
          "correct": 1,
          "explanation": "explained_variance_ratio_[i] gives the fraction of the total variance explained by the i-th principal component. Summing the top k values tells you what proportion of information is retained when reducing to k dimensions."
        },
        {
          "id": 3,
          "question": "How does DBSCAN handle outliers that don't belong to any dense cluster?",
          "options": [
            "It creates a separate 'noise' cluster for them",
            "It labels them as -1 (noise points)",
            "It assigns them to the nearest cluster centroid",
            "It removes them from the dataset"
          ],
          "correct": 1,
          "explanation": "DBSCAN labels points that are not reachable from any core point as -1 (noise). This is a feature, not a bug — it allows DBSCAN to naturally identify outliers/anomalies without forcing them into a cluster."
        }
      ]
    }
  },
  {
    "title": "Model Evaluation: Cross-Validation, Metrics, Calibration & Bias-Variance",
    "duration": "70 min", "videoUrl": "",
    "description": "Choose the right metric and avoid leakage that invalidates validation results.",
    "notes": {
      "overview": "Model evaluation answers: how well will this model perform on unseen data? A single train/test split is high-variance — k-fold cross-validation provides a more stable estimate by averaging across k non-overlapping test folds. Choosing the right metric for the business objective is as important as the model architecture.",
      "keyPoints": [
        "k-fold cross-validation (k=5 or 10) gives a low-variance performance estimate — stratified k-fold preserves class proportions in each fold",
        "Accuracy is misleading for imbalanced datasets (99% accuracy on a 1% positive class = useless model that predicts all negatives)",
        "Precision = TP/(TP+FP) — 'of all predicted positives, how many were correct'. Recall = TP/(TP+FN) — 'of all actual positives, how many did we find'",
        "The F1 score harmonises precision and recall: F1 = 2×(P×R)/(P+R). Use F-beta to weight recall more heavily when false negatives are costlier",
        "A calibrated model's predicted probability 0.8 should correspond to ~80% observed positives — check with a calibration curve (reliability diagram)"
      ],
      "codeExample": "from sklearn.model_selection import StratifiedKFold, cross_validate\nfrom sklearn.metrics import make_scorer, f1_score\n\ncv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)\nscoring = {\n  'roc_auc': 'roc_auc',\n  'f1': make_scorer(f1_score),\n  'precision': 'precision',\n  'recall': 'recall'\n}\n\nresults = cross_validate(model, X, y, cv=cv, scoring=scoring, return_train_score=True)\nprint('Val AUC:', results['test_roc_auc'].mean().round(3), '±', results['test_roc_auc'].std().round(3))",
      "deepDive": "A large gap between training score and validation score (high train AUC, low val AUC) is the signature of high variance (overfitting). A model where both scores are low has high bias (underfitting). The bias-variance tradeoff means you cannot eliminate both simultaneously — regularisation reduces variance at the cost of some bias. Finding the right balance is hyperparameter tuning.",
      "summary": "Stratified cross-validation with task-appropriate metrics is the correct evaluation protocol — accuracy alone is rarely sufficient for real-world data science problems."
    },
    "exercise": {
      "title": "Quiz: Model Evaluation Metrics",
      "timeLimit": 14,
      "questions": [
        {
          "id": 1,
          "question": "A cancer screening model has 98% accuracy. The disease affects 2% of the population. What is wrong with using accuracy here?",
          "options": [
            "Nothing — 98% accuracy is excellent",
            "A model that predicts 'no cancer' for everyone achieves 98% accuracy, but recalls zero actual cancer cases",
            "Accuracy cannot be used for medical data",
            "The model needs more training data"
          ],
          "correct": 1,
          "explanation": "With 2% prevalence, a trivial classifier always predicting 'negative' achieves 98% accuracy. This model is useless clinically — it detects no cases. Recall (sensitivity) — the proportion of actual positives correctly identified — is the critical metric for screening."
        },
        {
          "id": 2,
          "question": "When should you favour recall over precision?",
          "options": [
            "When false positives are more costly than false negatives",
            "When false negatives are more costly than false positives (e.g. failing to detect a disease or fraud)",
            "When the dataset is balanced",
            "When you want the highest possible F1 score"
          ],
          "correct": 1,
          "explanation": "High recall minimises false negatives. In medical screening or fraud detection, missing a true positive (undetected cancer, undetected fraud) is far more costly than investigating a false alarm — use high-recall, lower-precision models in these domains."
        },
        {
          "id": 3,
          "question": "What does a train AUC of 0.97 and validation AUC of 0.71 indicate?",
          "options": [
            "The model is well-calibrated",
            "High variance — the model is overfitting the training data",
            "High bias — the model is underfitting",
            "The validation dataset is too small"
          ],
          "correct": 1,
          "explanation": "A large train-validation performance gap (97% vs 71%) is the classic signature of overfitting (high variance). The model learned the training data too specifically — including noise — and fails to generalise. Apply regularisation, reduce model complexity, or add more data."
        }
      ]
    }
  }
]
$ds$::jsonb
WHERE title = 'Data Science & Machine Learning';

COMMIT;
