"use client";

import { useEffect, useRef } from "react";

type LegacyConfig = {
  type: "FOT_CONFIG";
  supabaseUrl: string;
  supabaseAnonKey: string;
  workspaceId: string;
  viewOnly: boolean;
};

export default function LegacyPage() {
  const frameRef = useRef<HTMLIFrameElement | null>(null);

  useEffect(() => {
    const frame = frameRef.current;
    if (!frame) return;

    const sendConfig = () => {
      const url = new URL(window.location.href);
      const workspaceId = url.searchParams.get("w") || "default";
      const mode = (url.searchParams.get("mode") || "").toLowerCase();
      const cfg: LegacyConfig = {
        type: "FOT_CONFIG",
        supabaseUrl: process.env.NEXT_PUBLIC_SUPABASE_URL || "",
        supabaseAnonKey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "",
        workspaceId,
        viewOnly: mode === "view",
      };
      frame.contentWindow?.postMessage(cfg, window.location.origin);
    };

    frame.addEventListener("load", sendConfig);
    sendConfig();
    return () => frame.removeEventListener("load", sendConfig);
  }, []);

  return (
    <main style={{ height: "100vh", margin: 0 }}>
      <iframe
        ref={frameRef}
        src="/legacy/index.html"
        style={{ width: "100%", height: "100%", border: 0 }}
        title="Legacy MVP"
      />
    </main>
  );
}
