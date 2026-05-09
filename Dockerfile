# ১. বেস ইমেজ হিসেবে নোড ব্যবহার করছি
FROM node:24-alpine AS builder

# ২. কন্টেইনারের ভেতরে কোন ফোল্ডারে কাজ হবে
WORKDIR /app

# ৩. আগে প্যাকেজ ফাইলগুলো কপি করছি (স্পিড বাড়ানোর জন্য)
COPY package*.json ./

# ৪. ডিপেন্ডেন্সি ইনস্টল করছি
RUN npm install

# ৫. প্রজেক্টের সব ফাইল কপি করছি
COPY . .

# ৬. নেক্সট জেএস প্রজেক্ট বিল্ড করছি
RUN npm run build

# ৭. কন্টেইনারটি কত পোর্টে চলবে (Next.js ডিফল্ট ৩০০০ পোর্টে চলে)

# production stage(image optimaize)

FROM node:24-alpine AS runner
WORKDIR /app

# builder images copy
COPY --from=builder /app/next.config.ts ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json


EXPOSE 3000

# ৮. প্রজেক্ট চালু করার কমান্ড
CMD ["npm", "start"]