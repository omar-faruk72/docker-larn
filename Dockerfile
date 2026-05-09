# ১. বিল্ড স্টেজ
FROM node:24-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# ২. রানার স্টেজ (এটিই আপনার ফাইনাল একক ইমেজ হবে)
FROM node:24-alpine AS runner
WORKDIR /app

# শুধুমাত্র প্রয়োজনীয় ফাইলগুলো কপি করা হচ্ছে
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

# প্রোডাকশন ইমেজের জন্য 'npm start' ব্যবহার করা ভালো
CMD ["npm", "start"]