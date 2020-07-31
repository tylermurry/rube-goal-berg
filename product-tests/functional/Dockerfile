FROM cypress/included:4.11.0
COPY . .
RUN npm install
ENTRYPOINT npm run ci:$TEST_SCOPE
