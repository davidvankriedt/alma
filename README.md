# alma
A decentralised music distributor.

Purpose:
Alma is a decentralised, location-based network of music, for listeners to access music without intermediaries, and for artists to be paid accordingly for their work.

Roles:
Artist - Uploads track, sets price per stream.
Listener - Discovers and streams tracks, paying micro-fee per stream.
Radio - User who locally chaches song, and broadcasts songs so others can find them.

Core flow:
1. Artist uploads song, song hash stored on IPFS
2. Smart contract records: Artist wallet, price per stream, metadata.
3. Listener wants to play, then pays micro-fee, contract forwards to artist.
4. Song distributed p2p (from nearby radio or through IPFS).

Rules:
1.  Users only see tracks available in their local region, unless they physically travel.
2.  Artists retain 100% ownership.

MVP:
1.  1 song upload
2.  Streaming via p2p
3.  Micro-payment smart contract