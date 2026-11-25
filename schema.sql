-- ========================================================
-- Polyship AI Music — Database Schema (PostgreSQL / Supabase)
-- Supporting Google, Suno, Naver, Kakao OAuth & Cloud Sync
-- ========================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users Table (Core Profile)
CREATE TABLE IF NOT EXISTS public.polyship_users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE,
    artist_name VARCHAR(100) NOT NULL DEFAULT 'AI Creator',
    handle VARCHAR(50) UNIQUE NOT NULL,
    avatar_url TEXT DEFAULT 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&h=300&fit=crop',
    banner_url TEXT DEFAULT 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=1400&h=400&fit=crop',
    bio TEXT,
    primary_ai_tool VARCHAR(100) DEFAULT 'Neural Sound Master v3.5',
    primary_genre VARCHAR(100) DEFAULT 'K-POP / Cyberpunk',
    link_youtube TEXT,
    link_threads TEXT,
    link_instagram TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. OAuth & Third-party Service Links (Google, Suno, Naver, Kakao)
CREATE TABLE IF NOT EXISTS public.polyship_oauth_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.polyship_users(id) ON DELETE CASCADE,
    provider VARCHAR(20) NOT NULL CHECK (provider IN ('google', 'suno', 'naver', 'kakao')),
    provider_user_id VARCHAR(255) NOT NULL,
    provider_email VARCHAR(255),
    provider_display_name VARCHAR(255),
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}'::jsonb,
    is_connected BOOLEAN DEFAULT true,
    connected_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(provider, provider_user_id)
);

-- 3. AI Music Tracks Table
CREATE TABLE IF NOT EXISTS public.polyship_tracks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    slug VARCHAR(255) UNIQUE NOT NULL,
    user_id UUID REFERENCES public.polyship_users(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    artist_name VARCHAR(255) NOT NULL,
    ai_model VARCHAR(100) NOT NULL DEFAULT 'Neural Audio v3.5',
    genre VARCHAR(100) NOT NULL DEFAULT 'EDM',
    bpm VARCHAR(20),
    musical_key VARCHAR(20),
    duration VARCHAR(20) DEFAULT '03:30',
    cover_url TEXT NOT NULL,
    audio_url TEXT,
    prompt TEXT,
    notes TEXT,
    play_count BIGINT DEFAULT 0,
    like_count BIGINT DEFAULT 0,
    is_verified BOOLEAN DEFAULT true,
    is_commercial_free BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. User Likes & Favorites
CREATE TABLE IF NOT EXISTS public.polyship_likes (
    user_id UUID REFERENCES public.polyship_users(id) ON DELETE CASCADE,
    track_id UUID REFERENCES public.polyship_tracks(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    PRIMARY KEY(user_id, track_id)
);

-- Indexes for high-performance chart queries
CREATE INDEX IF NOT EXISTS idx_tracks_play_count ON public.polyship_tracks(play_count DESC);
CREATE INDEX IF NOT EXISTS idx_tracks_created_at ON public.polyship_tracks(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_oauth_user_provider ON public.polyship_oauth_accounts(user_id, provider);
