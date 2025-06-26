 <schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        queryBinding="xslt2">
<pattern id="swmath-identifier-validation">
        <title>Validation of swMATH identifier</title>

        <rule context="identifier[@identifierType='swMATH']">

            <!-- 1. Identifier value must not be empty -->
            <assert test="normalize-space(.) != ''">
                swMATH identifier must have a non-empty value
            </assert>

            <!-- 2. Identifier value should be numeric (optional) -->
            <assert test="matches(., '^\d+$')">
                swMATH identifier should be numeric
            </assert>

        </rule>
    </pattern>

<pattern id="creator-from-authors-validation">
        <title>Validation of creator elements transformed from authors</title>

        <!-- Apply rule to every creator element -->
        <rule context="creator">

            <!-- 1. creatorName must exist and have the correct attribute -->
            <assert test="creatorName[@nameType='Personal']">
                creator must contain creatorName with nameType="Personal"
            </assert>

            <!-- 2. All values must be present and not empty -->
            <assert test="normalize-space(creatorName) != ''">
                creatorName must not be empty (use ':unav' if unavailable)
            </assert>
            <assert test="normalize-space(givenName) != ''">
                givenName must not be empty (use ':unav' if unavailable)
            </assert>
            <assert test="normalize-space(familyName) != ''">
                familyName must not be empty (use ':unav' if unavailable)
            </assert>

            <!-- 3. If any one field is ':unav', then all must be ':unav' -->
            <assert test="not(creatorName = ':unav' or givenName = ':unav' or familyName = ':unav')
                          or (creatorName = ':unav' and givenName = ':unav' and familyName = ':unav')">
                If any of creatorName, givenName, or familyName is ':unav', then all three must be ':unav'
            </assert>

            <!-- 4. If not :unav, creatorName should include comma separating surname and given name -->
            <assert test="creatorName = ':unav' or contains(creatorName, ',')">
                creatorName should contain a comma separating surname and given name unless it is ':unav'
            </assert>

        </rule>
    </pattern>
</schema>