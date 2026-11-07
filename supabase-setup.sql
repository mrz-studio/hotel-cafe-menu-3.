-- اجرا در Supabase > SQL Editor
create table if not exists public.menu_categories (
  id text primary key,
  title text not null,
  description text default '',
  eyebrow text default '',
  sort_order integer not null default 0,
  enabled boolean not null default true
);
create table if not exists public.menu_items (
  id text primary key,
  category_id text not null references public.menu_categories(id) on delete cascade,
  name text not null,
  image_url text default '',
  sort_order integer not null default 0,
  active boolean not null default true
);
create table if not exists public.site_settings (
  key text primary key,
  value jsonb not null default '{}'::jsonb
);
alter table public.menu_categories enable row level security;
alter table public.menu_items enable row level security;
alter table public.site_settings enable row level security;
drop policy if exists "Public can read categories" on public.menu_categories;
create policy "Public can read categories" on public.menu_categories for select to anon, authenticated using (true);
drop policy if exists "Authenticated manage categories" on public.menu_categories;
create policy "Authenticated manage categories" on public.menu_categories for all to authenticated using (true) with check (true);
drop policy if exists "Public can read items" on public.menu_items;
create policy "Public can read items" on public.menu_items for select to anon, authenticated using (true);
drop policy if exists "Authenticated manage items" on public.menu_items;
create policy "Authenticated manage items" on public.menu_items for all to authenticated using (true) with check (true);
drop policy if exists "Public can read settings" on public.site_settings;
create policy "Public can read settings" on public.site_settings for select to anon, authenticated using (true);
drop policy if exists "Authenticated manage settings" on public.site_settings;
create policy "Authenticated manage settings" on public.site_settings for all to authenticated using (true) with check (true);
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('menu-images','menu-images',true,5242880,array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;
drop policy if exists "Public read menu images" on storage.objects;
create policy "Public read menu images" on storage.objects for select to anon, authenticated using (bucket_id='menu-images');
drop policy if exists "Authenticated upload menu images" on storage.objects;
create policy "Authenticated upload menu images" on storage.objects for insert to authenticated with check (bucket_id='menu-images');
drop policy if exists "Authenticated update menu images" on storage.objects;
create policy "Authenticated update menu images" on storage.objects for update to authenticated using (bucket_id='menu-images') with check (bucket_id='menu-images');
drop policy if exists "Authenticated delete menu images" on storage.objects;
create policy "Authenticated delete menu images" on storage.objects for delete to authenticated using (bucket_id='menu-images');
