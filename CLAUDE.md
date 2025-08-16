# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Model Context Protocol (MCP) server that integrates Perplexity's Sonar API to provide Claude with real-time web research capabilities. The server exposes three tools:
- `perplexity_ask` - General chat completions using sonar-pro model
- `perplexity_research` - Deep research using sonar-deep-research model  
- `perplexity_reason` - Reasoning tasks using sonar-reasoning-pro model

## Development Commands

**Build the project:**
```bash
cd perplexity-ask && npm run build
```

**Watch mode for development:**
```bash
cd perplexity-ask && npm run watch
```

**Install dependencies:**
```bash
cd perplexity-ask && npm install
```

**Docker build:**
```bash
cd perplexity-ask && docker build -t mcp/perplexity-ask:latest -f Dockerfile .
```

## Environment Requirements

- Node.js >= 18
- `PERPLEXITY_API_KEY` environment variable must be set
- The server fails to start without the API key

## Architecture

**Single-file server structure:**
- `index.ts` - Complete MCP server implementation with three tool definitions
- Built on `@modelcontextprotocol/sdk` for MCP protocol handling
- Uses Node.js fetch API for Perplexity API calls
- TypeScript compiled to `dist/index.js` for execution

**Core components:**
- Tool definitions with input schemas for message arrays
- `performChatCompletion()` function that handles API calls to different Perplexity models
- Request handlers for `ListToolsRequestSchema` and `CallToolRequestSchema`
- Error handling for network issues and API responses
- Citation appending when available from Perplexity responses

**API Integration:**
- Uses Perplexity Chat Completions endpoint: `https://api.perplexity.ai/chat/completions`
- Bearer token authentication with `PERPLEXITY_API_KEY`
- Model selection based on tool type (sonar-pro, sonar-deep-research, sonar-reasoning-pro)

## Configuration

The server is designed to be used with Claude Desktop or other MCP-compatible clients. Configuration involves:
1. Setting up `PERPLEXITY_API_KEY` environment variable
2. Adding server configuration to `claude_desktop_config.json`
3. Can run via Docker or npx for distribution

## Package Configuration

- ESM module type with TypeScript compilation
- Main entry: `dist/index.js`
- Binary: `mcp-server-perplexity-ask`
- Dependencies: MCP SDK, axios, dotenv
- Build process includes executable permissions via shx