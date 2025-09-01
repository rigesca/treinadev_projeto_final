FROM ruby:2.6.10

# Instala dependências do sistema
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn

# Cria diretório de trabalho
WORKDIR /app

# Copia Gemfile primeiro (cache das gems)
COPY Gemfile Gemfile.lock ./

# Instala bundler e gems
RUN gem install bundler -v 2.4.22 \
    && bundle install

# Copia o restante do código
COPY . .

# Expõe a porta padrão do Rails
EXPOSE 3000

# Comando padrão (pode ser sobrescrito no compose)
CMD ["bash", "-c", "bundle exec rails s -b 0.0.0.0 -p 3000"]