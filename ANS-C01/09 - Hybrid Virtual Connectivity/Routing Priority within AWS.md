# Routing Priority within AWS

If choosing between two routes with equal specficity, AWS will choose the static (manually added) route over the dynamic (learned) route.

**Propagated Routes** Order: (highest to lowest priority)

- BGP (`dx`)
- Static Routes from VPN
- BGP (`VGW`)
- Lowest ASPATH
- Lowest MED

[^2]: Statement for simplicity