-- Supabase > SQL Editor > New query > yapıştır > Run

create table communities(id uuid primary key default gen_random_uuid(), name text not null, logo_url text, description text, projects text, created_at timestamptz default now());
create table announcements(id uuid primary key default gen_random_uuid(), community_id uuid references communities on delete cascade, title text not null, body text, created_at timestamptz default now());
create table ads(id uuid primary key default gen_random_uuid(), title text not null, text text, image_url text, link text, created_at timestamptz default now());
create table settings(key text primary key, value text);
create table students(
  id uuid primary key default gen_random_uuid(),
  first_name text not null check(length(first_name) between 2 and 60),
  last_name text not null check(length(last_name) between 2 and 60),
  student_no text not null check(student_no ~ '^[0-9]{6,15}$'),
  email text not null unique check(email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  phone text not null unique check(phone ~ '^[0-9]{10}$'),
  department text not null check(length(department) between 2 and 100),
  year text not null,
  kvkk boolean not null check(kvkk),
  contact_consent boolean not null check(contact_consent),
  status text not null default 'beklemede' check(status in ('beklemede','onaylı')),
  created_at timestamptz default now()
);

alter table communities enable row level security;
alter table announcements enable row level security;
alter table ads enable row level security;
alter table settings enable row level security;
alter table students enable row level security;

-- Herkes içeriği okuyabilir
create policy "oku" on communities for select using (true);
create policy "oku" on announcements for select using (true);
create policy "oku" on ads for select using (true);
create policy "oku" on settings for select using (true);
-- Sadece giriş yapmış yönetici düzenleyebilir
create policy "yonetici" on communities for all to authenticated using (true) with check (true);
create policy "yonetici" on announcements for all to authenticated using (true) with check (true);
create policy "yonetici" on ads for all to authenticated using (true) with check (true);
create policy "yonetici" on settings for all to authenticated using (true) with check (true);
-- Öğrenci kaydı: herkes EKLEYEBİLİR ama kimse OKUYAMAZ; sadece yönetici görür
create policy "kayit" on students for insert to anon with check (status = 'beklemede');
create policy "yonetici" on students for all to authenticated using (true) with check (true);

insert into settings values
('hero_title','Üniversitenin tüm topluluk duyuruları tek yerde.'),
('hero_sub','Topluluklara göz at, duyuruları takip et, etkinlikleri kaçırma.'),
('footer_text','Adyü Kampüs · Öğrenciler için, öğrenciler tarafından.');
