// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.0;

library Logo {
    function RESOURCE() external pure returns (string memory) {
        return
        '<svg width="80" height="180" x="15" y="90" viewBox="0 0 162 23" fill="none" xmlns="http://www.w3.org/2000/svg"> <g transform="rotate(-90)"><path d="M0 0.461094H8.36131V2.76815C8.77021 2.4101 9.20748 2.08583 9.66881 1.79852C10.5106 1.34217 11.4033 0.986775 12.3284 0.739724C13.6536 0.342414 15.0309 0.145815 16.4143 0.156461H17.0606C18.6593 0.123821 20.2529 0.345787 21.7818 0.81403C22.9433 1.16038 23.9962 1.8001 24.8388 2.67157C25.5238 3.4084 26.052 4.2767 26.3914 5.22382C26.7197 6.19899 26.8805 7.22273 26.8669 8.2516V8.89802C26.8751 9.93983 26.7042 10.9753 26.3617 11.9592C26.0016 12.9472 25.4528 13.8557 24.7459 14.6341C23.8841 15.544 22.8054 16.2202 21.6109 16.5994C20.0655 17.1128 18.4436 17.3578 16.8155 17.3238H16.2323C14.8883 17.3323 13.5491 17.1611 12.2504 16.8148C11.3338 16.5982 10.4461 16.274 9.60567 15.8489C9.16692 15.5979 8.7506 15.3095 8.36131 14.987V22.7887H0V0.461094ZM8.36131 8.63425V8.75685C8.36816 9.28725 8.49188 9.80961 8.72366 10.2867C8.95544 10.7638 9.28957 11.184 9.70224 11.5171C10.5838 12.3047 11.8542 12.6985 13.5133 12.6985H13.6693C15.3483 12.6985 16.5567 12.3097 17.2947 11.532C17.6536 11.1669 17.9368 10.7344 18.128 10.2594C18.3192 9.7844 18.4147 9.27629 18.409 8.76428V8.64167C18.4228 8.12833 18.3332 7.61746 18.1456 7.13943C17.958 6.66141 17.6762 6.226 17.3169 5.85909C16.5889 5.11608 15.3755 4.74457 13.6767 4.74457H13.5207C11.8195 4.74457 10.5392 5.12351 9.67996 5.88138C9.2684 6.21413 8.9364 6.63468 8.70825 7.11226C8.4801 7.58984 8.36157 8.11238 8.36131 8.64167V8.63425Z" fill="white"/><path d="M43.6234 14.7894C41.9444 16.4711 39.3616 17.312 35.8749 17.312H35.5369C32.9541 17.312 31.0337 16.7993 29.7757 15.7739C29.1901 15.3336 28.7157 14.7621 28.3906 14.1053C28.0655 13.4486 27.8987 12.7248 27.9036 11.992V11.6205C27.8707 10.9789 27.9949 10.3389 28.2655 9.75618C28.5361 9.17348 28.9448 8.66569 29.4563 8.27693C30.4889 7.48438 32.205 6.99647 34.6046 6.81319L42.5647 6.10733C43.1813 6.0256 43.4896 5.75811 43.4896 5.30859C43.4968 5.08591 43.4258 4.86775 43.2891 4.69189C42.9937 4.45123 42.6376 4.29693 42.2601 4.24608C41.4796 4.0948 40.685 4.02878 39.8903 4.04918H39.7677C39.0829 4.03761 38.3986 4.09361 37.7247 4.21636C37.3046 4.27251 36.9098 4.44931 36.5881 4.72532C36.4318 4.87451 36.2968 5.04452 36.1869 5.23057C36.1216 5.39434 36.0755 5.56513 36.0495 5.73953H28.2751V5.55378C28.2697 5.06855 28.3158 4.58413 28.4125 4.10862C28.5621 3.58249 28.8146 3.09128 29.1554 2.66345C29.5978 2.08536 30.1723 1.62167 30.8307 1.31117C31.8322 0.874995 32.8859 0.570303 33.9657 0.404694C35.5868 0.133525 37.2291 0.0091849 38.8725 0.0331869H40.5923C42.3003 0.0131301 44.0071 0.131157 45.696 0.386117C46.8137 0.53369 47.9083 0.822042 48.9536 1.2443C49.6289 1.53607 50.2286 1.97826 50.7069 2.53714C51.0674 2.93397 51.3351 3.40604 51.4906 3.91915C51.5899 4.38926 51.636 4.86904 51.6281 5.34945V11.4682C51.6144 11.5645 51.6234 11.6627 51.6542 11.755C51.6851 11.8474 51.7369 11.9312 51.8057 12C51.8746 12.0689 51.9584 12.1207 52.0507 12.1516C52.143 12.1824 52.2412 12.1914 52.3375 12.1778H53.229V17.0073H46.2978C44.76 17.0049 43.8685 16.2656 43.6234 14.7894ZM43.4711 9.90041V9.19455L37.9328 10.179C37.3834 10.2392 36.851 10.4058 36.3652 10.6694C36.2146 10.7693 36.0927 10.9069 36.0119 11.0686C35.9311 11.2303 35.8941 11.4103 35.9046 11.5908V11.6242C35.9039 11.8565 35.9576 12.0857 36.0615 12.2934C36.1654 12.5012 36.3165 12.6817 36.5027 12.8205C36.9038 13.1511 37.5724 13.3146 38.5159 13.3146C40.0017 13.3146 41.1953 12.9715 42.0967 12.2855C42.9981 11.5994 43.4562 10.8044 43.4711 9.90041Z" fill="white"/><path d="M54.6875 17.004V0.460789H62.9894V3.38455C63.2977 3.09477 63.5391 2.87558 63.7323 2.72326C64.095 2.42908 64.4746 2.15619 64.8689 1.90596C65.4034 1.54408 65.975 1.24021 66.5739 0.999478C67.2803 0.740272 68.0055 0.535345 68.7431 0.386488C69.667 0.186718 70.6098 0.088309 71.555 0.0930003H71.7407C73.0509 0.0672597 74.3556 0.269646 75.5964 0.691121C76.5551 1.00549 77.4248 1.54426 78.1334 2.2626C78.6857 2.84349 79.1286 3.51933 79.4409 4.25759C79.7134 4.92653 79.8547 5.6417 79.8569 6.36404V17.004H71.4621V9.10205C71.516 8.0833 71.1678 7.08413 70.4927 6.31945C69.8488 5.63092 68.8397 5.2879 67.4654 5.29038C66.091 5.29038 65.0175 5.66189 64.2375 6.4049C63.8471 6.78108 63.5413 7.23599 63.3402 7.73944C63.1391 8.24288 63.0474 8.78334 63.0711 9.32495V17.0114L54.6875 17.004Z" fill="white"/><path d="M96.143 22.9998H93.7769C92.0497 23.0191 90.3249 22.8647 88.6286 22.5392C87.4438 22.3309 86.2944 21.9557 85.215 21.4246C84.4876 21.0445 83.8405 20.5273 83.3094 19.9015C82.9085 19.4562 82.5947 18.9395 82.3845 18.3783C82.2537 17.9611 82.1873 17.5264 82.1877 17.0892V16.9963H90.5787C90.7817 17.9176 92.2168 18.3783 94.8838 18.3783H94.9766C98.3172 18.3783 99.9875 16.9752 99.9875 14.1691V13.831C98.3457 15.4681 95.6601 16.2879 91.9308 16.2904H91.4404C87.9142 16.2904 85.3214 15.5412 83.6623 14.0428C82.8603 13.3453 82.2216 12.4798 81.7915 11.5078C81.3614 10.5357 81.1504 9.48092 81.1736 8.41819V7.86464C81.1533 6.83683 81.351 5.81638 81.7537 4.87056C82.1564 3.92474 82.755 3.07505 83.51 2.37748C85.0676 0.891452 87.5266 0.148438 90.887 0.148438H91.563C95.2107 0.148438 98.0077 0.957084 99.9541 2.57438V0.453076H108.319V14.2286C108.321 14.9795 108.233 15.7279 108.055 16.4576C107.833 17.2801 107.475 18.0598 106.997 18.7647C106.445 19.6008 105.74 20.3255 104.92 20.9008C103.834 21.6081 102.632 22.1187 101.369 22.4091C99.6594 22.8277 97.9031 23.0262 96.143 22.9998ZM94.6052 4.82943H94.4232C92.7219 4.82943 91.4974 5.14645 90.7495 5.78049C90.3956 6.0638 90.1112 6.42434 89.9181 6.83452C89.7249 7.2447 89.6282 7.69365 89.6352 8.14698V8.32159C89.6295 8.79609 89.73 9.26584 89.9292 9.6965C90.1285 10.1272 90.4214 10.5079 90.7867 10.8107C91.5568 11.4868 92.7715 11.8249 94.4306 11.8249H94.6126C96.346 11.8249 97.6585 11.4819 98.55 10.7958C98.9582 10.5231 99.2944 10.1557 99.5299 9.72481C99.7653 9.29396 99.893 8.81252 99.902 8.32159V8.22872C99.8979 7.74667 99.7734 7.27329 99.5399 6.85158C99.3063 6.42988 98.9712 6.07319 98.5648 5.81392C97.6684 5.15511 96.3485 4.82695 94.6052 4.82943Z" fill="white"/><path d="M135.624 10.9783V11.0377C135.628 11.5679 135.556 12.096 135.409 12.6055C135.194 13.2246 134.86 13.7952 134.424 14.2847C133.862 14.9477 133.172 15.4909 132.396 15.8822C131.259 16.416 130.055 16.791 128.816 16.9967C127.037 17.3248 125.231 17.4791 123.422 17.4574H121.791C120.055 17.4794 118.321 17.3037 116.625 16.9335C115.37 16.6802 114.166 16.2234 113.059 15.5813C112.221 15.0662 111.49 14.3938 110.908 13.6011C110.399 12.9174 110.021 12.1453 109.794 11.3238C109.594 10.546 109.495 9.74555 109.5 8.94243V8.322C109.5 2.76921 113.569 -0.00841767 121.706 -0.0108944H123.396C124.764 -0.0218437 126.13 0.076295 127.482 0.282594C128.537 0.435022 129.573 0.697755 130.572 1.06647C131.362 1.3644 132.102 1.7789 132.768 2.29616C133.327 2.72273 133.827 3.22254 134.254 3.78219C134.629 4.30074 134.929 4.86984 135.145 5.47254C135.353 6.04033 135.502 6.62789 135.591 7.22605C135.665 7.81258 135.701 8.40327 135.698 8.99443V9.91577H117.702C117.987 11.9492 119.657 12.9646 122.713 12.9621H122.742C123.408 12.9686 124.073 12.9063 124.726 12.7764C125.192 12.692 125.645 12.5523 126.078 12.3603C126.368 12.2279 126.633 12.047 126.862 11.8253C127.023 11.6792 127.158 11.5072 127.263 11.3163C127.321 11.1987 127.362 11.0737 127.385 10.9448L135.624 10.9783ZM122.56 4.06082C119.836 4.06082 118.248 4.89052 117.795 6.54992H127.326C126.977 4.88805 125.388 4.05834 122.56 4.06082Z" fill="white"/><path d="M152.38 14.7895C150.699 16.4712 148.116 17.312 144.632 17.312H144.294C141.711 17.312 139.789 16.7993 138.529 15.774C137.94 15.3349 137.463 14.7642 137.134 14.1075C136.806 13.4508 136.636 12.7263 136.638 11.992V11.6205C136.605 10.9789 136.729 10.3389 137 9.75622C137.27 9.17352 137.679 8.66573 138.191 8.27697C139.228 7.48442 140.944 6.99651 143.339 6.81323L151.303 6.10737C151.916 6.02564 152.224 5.75816 152.224 5.30863C152.231 5.08596 152.16 4.86779 152.023 4.69193C151.729 4.45043 151.372 4.29602 150.995 4.24612C150.215 4.09482 149.422 4.0288 148.628 4.04922H148.506C147.82 4.03767 147.134 4.09367 146.459 4.2164C146.14 4.24873 145.834 4.3579 145.567 4.53455C145.3 4.7112 145.08 4.95005 144.925 5.23061C144.858 5.39414 144.811 5.56496 144.784 5.73957H137.039V5.55382C137.032 5.06852 137.078 4.58389 137.177 4.10866C137.325 3.58206 137.578 3.09062 137.92 2.66349C138.36 2.08376 138.935 1.61972 139.595 1.31121C140.596 0.874483 141.65 0.569771 142.73 0.404734C144.35 0.133386 145.991 0.00904425 147.633 0.0332274H149.368C151.074 0.0132899 152.78 0.131317 154.468 0.386158C155.586 0.533658 156.682 0.822008 157.729 1.24434C158.403 1.53557 159.002 1.97789 159.478 2.53718C159.84 2.93305 160.108 3.40544 160.262 3.91919C160.363 4.38914 160.41 4.86894 160.403 5.34949V11.4682C160.389 11.5644 160.397 11.6625 160.428 11.7549C160.458 11.8472 160.51 11.9312 160.578 12.0001C160.647 12.0691 160.73 12.121 160.823 12.1519C160.915 12.1827 161.013 12.1916 161.109 12.1778H161.997V17.0074H155.051C153.515 17.0049 152.625 16.2656 152.38 14.7895ZM152.224 9.90045V9.19459L146.689 10.1791C146.14 10.2399 145.608 10.4064 145.122 10.6695C144.972 10.7698 144.85 10.9076 144.77 11.0691C144.689 11.2307 144.652 11.4105 144.661 11.5908V11.6243C144.661 11.8568 144.715 12.0862 144.82 12.294C144.924 12.5018 145.076 12.6821 145.263 12.8205C145.659 13.1499 146.33 13.3146 147.276 13.3146C148.551 13.3746 149.809 13.0129 150.857 12.2855C151.768 11.5995 152.224 10.8045 152.224 9.90045Z" fill="white"/> </g> </svg>';
    }
}
