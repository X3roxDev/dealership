Config = {}

Config.Locale = 'en'
Config.ShopTitle = "DEALERSHIP"
Config.ShopSubtitle = ""

Config.Debug = false

Config.Currency = "$"

Config.Target = 'ox_target'
Config.FallbackMarker = false

Config.TestDrive = {
    Enabled = true,
    Price = 0,
    Time = 30,
    ReturnLocation = vector4(-45.34, -1110.45, 26.44, 73.0),
    SpawnPoint = vector4(-11.43, -1080.4, 26.25, 128.97)
}

Config.CheckSpawnClear = false

Config.Blip = {
    Enabled = true,
    Sprite = 225,
    Display = 4,
    Scale = 0.8,
    Colour = 3,
    Name = "Dealership"
}

Config.Dealerships = {
    {
        coords = vector3(-55.6, -1098.11, 26.42),
        spawnPoint = vector4(-11.01, -1099.69, 26.25, 102.26),
        showBlip = true
    }
}

Config.Npc = {
    Enabled = true,
    Model = "s_m_m_highsec_01",
    Coords = vector4(-55.6, -1098.11, 26.42, 23.95)
}

Config.DisplayVehicles = {
    {
        coords = vector4(-48.39, -1091.79, 26.0, 110.48),
        model = "t20",
        neonColor = {r = 255, g = 255, b = 255},
        bodyColor = {r = 255, g = 255, b = 255}
    },
    {
        coords = vector4(-42.97, -1093.81, 26.0, 119.64),
        model = "comet3",
        neonColor = {r = 0, g = 255, b = 255},
        bodyColor = {r = 0, g = 255, b = 255}
    },
    {
        coords = vector4(-48.5, -1101.72, 26.35, 24.96),
        model = "fmj",
        neonColor = {r = 200, g = 160, b = 10},
        bodyColor = {r = 200, g = 160, b = 10}
    },
    {
        coords = vector4(-43.65, -1101.8, 26.0, 20.17),
        model = "zentorno",
        neonColor = {r = 76, g = 0, b = 150},
        bodyColor = {r = 0, g = 0, b = 0}
    },
    {
        coords = vector4(-37.53, -1088.23, 26.0, 247.66),
        model = "elegy",
        neonColor = {r = 255, g = 0, b = 0},
        bodyColor = {r = 0, g = 0, b = 0}
    }
}

Config.AllowedCategories = {
    compacts = true,
    coupes = true,
    sedans = true,
    suvs = true,
    muscle = true,
    sports = true,
    sportsclassics = true,
    super = true,
    offroad = true,
    vans = true,
    motorcycles = true
}

Config.BlacklistedModels = {
    oppressor = true,
    oppressor2 = true,
    deluxo = true,
    stromberg = true,
    ruiner2 = true,
    scramjet = true,
    toreador = true,
    vigilante = true,
    khanjali = true,
    rhino = true,
    apc = true,
    halftrack = true,
    barrage = true,
    insurgent = true,
    insurgent2 = true,
    insurgent3 = true,
    nightshark = true,
    menacer = true,
    dukeodeath = true,
    kuruma2 = true,
    jb7002 = true,
    riot = true,
    riot2 = true,
    police = true,
    police2 = true,
    police3 = true,
    police4 = true,
    policeb = true,
    polmav = true,
    ambulance = true,
    firetruk = true,
    lifeguard = true,
    sheriff = true,
    sheriff2 = true,
    fbi = true,
    fbi2 = true,
    stockade = true,
    stockade3 = true,
    mule4 = true,
    boxville5 = true,
    trash2 = true,
    towtruck = true,
    towtruck2 = true,
    flatbed = true,

    police5 = true,
    police6 = true,
    police7 = true,
    policeold1 = true,
    policeold2 = true,
    policet = true,
    pranger = true,
    pbus = true,

    boxville = true,
    boxville2 = true,
    boxville3 = true,
    boxville4 = true,
    mule = true,
    mule2 = true,
    mule3 = true,
    pounder = true,
    pounder2 = true,
    bus = true,
    coach = true,
    rentalbus = true,
    tourbus = true,
    taxi = true,
    gopostal = true,
    gopostal2 = true,
    utillitruck = true,
    utillitruck2 = true,
    utillitruck3 = true,

    technical = true,
    technical2 = true,
    technical3 = true,
    dune3 = true,
    dune4 = true,
    dune5 = true,

    baller5 = true,
    baller6 = true,
    schafter5 = true,
    schafter6 = true,
    cognoscenti2 = true,
    xls2 = true,
    limo2 = true
}

Config.CategoryLabels = {
    compacts = "Compacts",
    coupes = "Coupes",
    sedans = "Sedans",
    suvs = "SUVs",
    muscle = "Muscle",
    sports = "Sports",
    sportsclassics = "Sports Classics",
    super = "Super",
    offroad = "Off-Road",
    vans = "Vans",
    motorcycles = "Motorcycles"
}

Config.DefaultPrices = {
    compacts = 15000,
    coupes = 25000,
    sedans = 22000,
    suvs = 35000,
    muscle = 30000,
    sports = 120000,
    sportsclassics = 180000,
    super = 400000,
    offroad = 28000,
    vans = 20000,
    motorcycles = 12000
}

Config.FallbackPrice = 25000

Config.VehicleOverrides = {}

Config.Vehicles = {
    {
        model = "blista",
        label = "Blista",
        brand = "Dinka",
        price = 14000,
        category = "compacts",
        image = "blista.png"
    },
    {
        model = "brioso",
        label = "Brioso R/A",
        brand = "Grotti",
        price = 16000,
        category = "compacts",
        image = "brioso.png"
    },
    {
        model = "issi2",
        label = "Issi",
        brand = "Weeny",
        price = 15000,
        category = "compacts",
        image = "issi2.png"
    },
    {
        model = "panto",
        label = "Panto",
        brand = "Benefactor",
        price = 12000,
        category = "compacts",
        image = "panto.png"
    },
    {
        model = "prairie",
        label = "Prairie",
        brand = "Bollokan",
        price = 13000,
        category = "compacts",
        image = "prairie.png"
    },
    {
        model = "cogcabrio",
        label = "Cognoscenti Cabrio",
        brand = "Enus",
        price = 55000,
        category = "coupes",
        image = "cogcabrio.png"
    },
    {
        model = "exemplar",
        label = "Exemplar",
        brand = "Dewbauchee",
        price = 52000,
        category = "coupes",
        image = "exemplar.png"
    },
    {
        model = "f620",
        label = "F620",
        brand = "Ocelot",
        price = 48000,
        category = "coupes",
        image = "f620.png"
    },
    {
        model = "felon",
        label = "Felon",
        brand = "Lampadati",
        price = 45000,
        category = "coupes",
        image = "felon.png"
    },
    {
        model = "felon2",
        label = "Felon GT",
        brand = "Lampadati",
        price = 50000,
        category = "coupes",
        image = "felon2.png"
    },
    {
        model = "asea",
        label = "Asea",
        brand = "Declasse",
        price = 18000,
        category = "sedans",
        image = "asea.png"
    },
    {
        model = "asterope",
        label = "Asterope",
        brand = "Karin",
        price = 19000,
        category = "sedans",
        image = "asterope.png"
    },
    {
        model = "fugitive",
        label = "Fugitive",
        brand = "Cheval",
        price = 21000,
        category = "sedans",
        image = "fugitive.png"
    },
    {
        model = "ingot",
        label = "Ingot",
        brand = "Vulcar",
        price = 16000,
        category = "sedans",
        image = "ingot.png"
    },
    {
        model = "intruder",
        label = "Intruder",
        brand = "Karin",
        price = 20000,
        category = "sedans",
        image = "intruder.png"
    },
    {
        model = "baller",
        label = "Baller",
        brand = "Gallivanter",
        price = 45000,
        category = "suvs",
        image = "baller.png"
    },
    {
        model = "baller2",
        label = "Baller Sport",
        brand = "Gallivanter",
        price = 50000,
        category = "suvs",
        image = "baller2.png"
    },
    {
        model = "bjxl",
        label = "BeeJay XL",
        brand = "Karin",
        price = 38000,
        category = "suvs",
        image = "bjxl.png"
    },
    {
        model = "cavalcade",
        label = "Cavalcade",
        brand = "Albany",
        price = 40000,
        category = "suvs",
        image = "cavalcade.png"
    },
    {
        model = "cavalcade2",
        label = "Cavalcade II",
        brand = "Albany",
        price = 42000,
        category = "suvs",
        image = "cavalcade2.png"
    },
    {
        model = "blade",
        label = "Blade",
        brand = "Vapid",
        price = 32000,
        category = "muscle",
        image = "blade.png"
    },
    {
        model = "buccaneer",
        label = "Buccaneer",
        brand = "Albany",
        price = 30000,
        category = "muscle",
        image = "buccaneer.png"
    },
    {
        model = "chino",
        label = "Chino",
        brand = "Vapid",
        price = 31000,
        category = "muscle",
        image = "chino.png"
    },
    {
        model = "dominator",
        label = "Dominator",
        brand = "Vapid",
        price = 34000,
        category = "muscle",
        image = "dominator.png"
    },
    {
        model = "dukes",
        label = "Dukes",
        brand = "Imponte",
        price = 33000,
        category = "muscle",
        image = "dukes.png"
    },
    {
        model = "alpha",
        label = "Alpha",
        brand = "Albany",
        price = 85000,
        category = "sports",
        image = "alpha.png"
    },
    {
        model = "banshee",
        label = "Banshee",
        brand = "Bravado",
        price = 90000,
        category = "sports",
        image = "banshee.png"
    },
    {
        model = "carbonizzare",
        label = "Carbonizzare",
        brand = "Grotti",
        price = 110000,
        category = "sports",
        image = "carbonizzare.png"
    },
    {
        model = "comet2",
        label = "Comet",
        brand = "Pfister",
        price = 95000,
        category = "sports",
        image = "comet2.png"
    },
    {
        model = "comet3",
        label = "Comet SR",
        brand = "Pfister",
        price = 120000,
        category = "sports",
        image = "comet3.png"
    },
    {
        model = "btype",
        label = "Roosevelt",
        brand = "Albany",
        price = 150000,
        category = "sportsclassics",
        image = "btype.png"
    },
    {
        model = "casco",
        label = "Casco",
        brand = "Lampadati",
        price = 145000,
        category = "sportsclassics",
        image = "casco.png"
    },
    {
        model = "coquette2",
        label = "Coquette Classic",
        brand = "Invetero",
        price = 140000,
        category = "sportsclassics",
        image = "coquette2.png"
    },
    {
        model = "feltzer3",
        label = "Stirling GT",
        brand = "Benefactor",
        price = 155000,
        category = "sportsclassics",
        image = "feltzer3.png"
    },
    {
        model = "adder",
        label = "Adder",
        brand = "Truffade",
        price = 1200000,
        category = "super",
        image = "adder.png"
    },
    {
        model = "cheetah",
        label = "Cheetah",
        brand = "Grotti",
        price = 1150000,
        category = "super",
        image = "cheetah.png"
    },
    {
        model = "entityxf",
        label = "Entity XF",
        brand = "Overflod",
        price = 1250000,
        category = "super",
        image = "entityxf.png"
    },
    {
        model = "infernus",
        label = "Infernus",
        brand = "Pegassi",
        price = 1100000,
        category = "super",
        image = "infernus.png"
    },
    {
        model = "osiris",
        label = "Osiris",
        brand = "Pegassi",
        price = 1600000,
        category = "super",
        image = "osiris.png"
    },
    {
        model = "bfinjection",
        label = "Bf Injection",
        brand = "BF",
        price = 28000,
        category = "offroad",
        image = "bfinjection.png"
    },
    {
        model = "brawler",
        label = "Brawler",
        brand = "Coil",
        price = 45000,
        category = "offroad",
        image = "brawler.png"
    },
    {
        model = "dubsta3",
        label = "Dubsta 6x6",
        brand = "Benefactor",
        price = 60000,
        category = "offroad",
        image = "dubsta3.png"
    },
    {
        model = "dune",
        label = "Dune",
        brand = "Annis",
        price = 30000,
        category = "offroad",
        image = "dune.png"
    },
    {
        model = "bison",
        label = "Bison",
        brand = "Bravado",
        price = 22000,
        category = "vans",
        image = "bison.png"
    },
    {
        model = "bobcatxl",
        label = "Bobcat XL",
        brand = "Vapid",
        price = 21000,
        category = "vans",
        image = "bobcatxl.png"
    },
    {
        model = "burrito3",
        label = "Burrito",
        brand = "Declasse",
        price = 20000,
        category = "vans",
        image = "burrito3.png"
    },
    {
        model = "gburrito",
        label = "Gang Burrito",
        brand = "Declasse",
        price = 23000,
        category = "vans",
        image = "gburrito.png"
    },
    {
        model = "akuma",
        label = "Akuma",
        brand = "Dinka",
        price = 18000,
        category = "motorcycles",
        image = "akuma.png"
    },
    {
        model = "bati",
        label = "Bati 801",
        brand = "Pegassi",
        price = 22000,
        category = "motorcycles",
        image = "bati.png"
    },
    {
        model = "carbonrs",
        label = "Carbon RS",
        brand = "Nagasaki",
        price = 24000,
        category = "motorcycles",
        image = "carbonrs.png"
    }
}

