// Nagebootste Supabase: houdt tabellen in het geheugen en volgt dezelfde
// toegangsregels als de database, zodat de pagina echt getest kan worden.
window.__NEP = {
  leden: [{ email: "mk@mobielecollectie.nl", naam: "Marinus", rol: "beheerder" },
          { email: "kijker@example.org", naam: "Kijker", rol: "kijker" }],
  organisaties: [], personen: [], categorieen: [], acties: [], besluiten: [],
  ingelogdAls: null, schrijfacties: []
};
if (window.__VOORAF) Object.assign(window.__NEP, window.__VOORAF);

window.__maakClient = function () {
  var D = window.__NEP;
  function rol() {
    var l = D.leden.find(function (x) { return x.email === (D.ingelogdAls || ""); });
    return l ? l.rol : null;
  }
  function magBewerken() { return rol() === "bewerker" || rol() === "beheerder"; }
  function kopie(x) { return JSON.parse(JSON.stringify(x)); }

  function tabel(naam) {
    var q = {
      select: function () { return q; },
      order: function (veld) {
        q._order = veld; return q;
      },
      eq: function (v, w) { q._eq = [v, w]; return q; },
      in: function (v, lijst) { q._in = [v, lijst]; return q; },
      then: function (res, rej) { return q._uitvoeren().then(res, rej); },
      _uitvoeren: function () {
        if (!rol()) return Promise.resolve({ data: [], error: null });   // ziet niets
        var rijen = kopie(D[naam] || []);
        if (q._order) rijen.sort(function (a, b) {
          return String(a[q._order]).localeCompare(String(b[q._order]), "nl", { numeric: true });
        });
        return Promise.resolve({ data: rijen, error: null });
      },
      upsert: function (rijen) {
        if (!magBewerken()) return Promise.resolve({ error: { message: "geweigerd" } });
        (Array.isArray(rijen) ? rijen : [rijen]).forEach(function (r) {
          D.schrijfacties.push([naam, "upsert", r.id]);
          var i = D[naam].findIndex(function (x) { return x.id === r.id; });
          if (i === -1) D[naam].push(kopie(r)); else D[naam][i] = kopie(r);
        });
        return Promise.resolve({ error: null });
      },
      delete: function () {
        var d = {
          in: function (_v, lijst) {
            if (!magBewerken()) return Promise.resolve({ error: { message: "geweigerd" } });
            lijst.forEach(function (id) { D.schrijfacties.push([naam, "delete", id]); });
            D[naam] = D[naam].filter(function (x) { return lijst.indexOf(x.id) === -1; });
            return Promise.resolve({ error: null });
          },
          eq: function (_v, id) {
            if (!magBewerken()) return Promise.resolve({ error: { message: "geweigerd" } });
            D.schrijfacties.push([naam, "delete", id]);
            D[naam] = D[naam].filter(function (x) { return x.id !== id; });
            if (naam === "organisaties") {
              D.personen.forEach(function (x) { if (x.organisatie_id === id) x.organisatie_id = null; });
              D.acties.forEach(function (a) { if (a.organisatie_id === id) a.organisatie_id = null; });
            }
            if (naam === "personen") {
              D.acties.forEach(function (a) { if (a.persoon_id === id) a.persoon_id = null; });
            }
            return Promise.resolve({ error: null });
          }
        };
        return d;
      }
    };
    return q;
  }

  var luisteraar = null;
  return {
    from: tabel,
    channel: function () {
      return { on: function () { return this; }, subscribe: function () { return this; } };
    },
    auth: {
      getSession: function () {
        return Promise.resolve({ data: { session: D.ingelogdAls ? { user: { id: D.ingelogdAls, email: D.ingelogdAls } } : null } });
      },
      onAuthStateChange: function (fn) { luisteraar = fn; return { data: {} }; },
      signInWithOtp: function (o) {
        D.ingelogdAls = o.email;
        setTimeout(function () {
          if (luisteraar) luisteraar("SIGNED_IN", { user: { id: o.email, email: o.email } });
        }, 20);
        return Promise.resolve({ error: null });
      },
      signOut: function () { D.ingelogdAls = null; return Promise.resolve({}); }
    }
  };
};
