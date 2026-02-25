export default function LegacyPage() {
  return (
    <main style={{ height: "100vh", margin: 0 }}>
      <iframe
        src="/wrapper.html"
        style={{ width: "100%", height: "100%", border: 0 }}
        title="Legacy MVP"
      />
    </main>
  );
}