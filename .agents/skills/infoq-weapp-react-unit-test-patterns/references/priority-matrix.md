# Priority Matrix

## P0: Core Runtime And Request Branches

- `src/mobile-core/request.ts`
- `src/mobile-core/auth.ts`
- `src/mobile-core/crypto.ts`
- `src/mobile-core/rsa.ts`
- `src/mobile-core/env.ts`

Focus:
- Header/token branch coverage
- Encryption/no-encryption branches
- Error mapping and thrown error types
- weapp vs h5 runtime URL composition branches

## P1: API Wrapper Contracts And Permissions

- `src/mobile-core/api/**/*.ts`
- `src/mobile-core/permissions.ts`

Focus:
- Every API wrapper export is covered by at least one test
- Method/url/transport contract assertions
- Permission normalization and wildcard behavior

## P2: Store Session Behavior

- `src/store/session.ts`

Focus:
- `loadSession` cache and force-refresh branches
- `signIn` token persistence and permission normalization
- `signOut` success/failure cleanup behavior
- `hasPermission` delegation behavior
