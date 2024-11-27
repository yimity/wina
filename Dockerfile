FROM node:20.18-alpine3.19 AS base

WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY public ./public
COPY prisma ./prisma
COPY script.sh ./script.sh

RUN chmod +x script.sh
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --chown=nextjs:nodejs .next/standalone ./
COPY --chown=nextjs:nodejs .next/static ./.next/static

USER nextjs

ENV AUTH_TRUST_HOST true
ENV NODEJS_HELPERS 0

EXPOSE 3000

ENV PORT 3000

CMD ./script.sh
